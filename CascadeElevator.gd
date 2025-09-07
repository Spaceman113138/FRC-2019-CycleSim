class_name CascadeElevator extends Node3D

@export var components: Array[RigidBody3D] = []
@export var maxHeight: float = 1.0
@export var maxForce: float = 1.0

var jointArray: Array[JoltSliderJoint3D] = []
var initalRotations: Array[Vector3] = []
var initalBasis: Array[Basis] = []
var initialOffsets: Array[Vector3] = []
var atPosition := false
var atPositionArray: Array[bool] = []:
	set(val):
		atPositionArray = val
		for value in atPositionArray:
			if value == false:
				atPosition = false
				return
		atPosition = true

@export var targetHeight: float = 0.0
@export var tolorence: float = 0.01
@export var P: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if len(components) < 2:
		push_error("Need at least 2 components for elevator")
	
	for i in range(len(components) - 1):
		var jointNode = getConfiguredJoint()
		jointNode.node_a = components[i].get_path()
		jointNode.node_b = components[i+1].get_path()
		jointNode.position = components[i+1].position
		jointArray.append(jointNode)
		
		initialOffsets.append(components[i+1].global_position - components[i].global_position)
		initalRotations.append(components[i].global_rotation)
		initalBasis.append(jointArray[i].global_basis)
		atPositionArray.append(false)


func getConfiguredJoint() -> JoltSliderJoint3D:
	var joint := JoltSliderJoint3D.new()
	add_child(joint)
	joint.rotation_degrees = Vector3(Vector3(0, 0, 90))
	joint.solver_position_iterations = 500
	joint.solver_velocity_iterations = 500
	joint.limit_enabled = true
	joint.limit_lower = 0.0
	joint.limit_upper = maxHeight
	joint.motor_enabled = true
	joint.motor_max_force = maxForce
	return joint


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	for i in range(len(jointArray)):
		var rotationDelta := components[i].global_rotation - initalRotations[i]
		var tempJointInitialBasis = initalBasis[i].rotated(Vector3.UP, rotationDelta.y)
		tempJointInitialBasis = tempJointInitialBasis.rotated(Vector3.RIGHT, rotationDelta.x)
		tempJointInitialBasis = tempJointInitialBasis.rotated(Vector3.BACK, rotationDelta.z)
		var axis = rotateThing(initalBasis[i], rotationDelta).orthonormalized().x
		var positionDelta := components[i+1].global_position - components[i].global_position - Vector3(rotateThing(initialOffsets[i], rotationDelta))
		var currentHeight := positionDelta.project(axis).length()
		
		var error := targetHeight - currentHeight
		if abs(error) >= tolorence:
			jointArray[i].motor_target_velocity = error * P
			atPositionArray[1] = false
		else:
			jointArray[i].motor_target_velocity = 0
			atPositionArray[i] = true


func rotateThing(thing, rotationVector):
	var tempThing = thing.rotated(Vector3.UP, rotationVector.y)
	tempThing = tempThing.rotated(Vector3.RIGHT, rotationVector.x)
	tempThing = tempThing.rotated(Vector3.BACK, rotationVector.z)
	return tempThing
