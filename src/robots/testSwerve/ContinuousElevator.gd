class_name ContinuousElevator extends Node3D


@export var components: Array[RigidBody3D]
var joints: Array[JoltSliderJoint3D]

var currentHeight: float = 0
@export var targetHeight: float = 0.0:
	set(val):
		targetHeight = val
		_physics_process(0.0)
@export var tolorence: float = 0.01
@export var maxHeight: float = 1.5
var atTargetHeight: bool = true

var directionVectior: Vector3 = Vector3(0, 1, 0)#Defines the axis that the elevetor moves on

var staticStageAnchor
var carrageStageAnchor

var initalOffset: Vector3
var initialRotation: Vector3
var jointInitialBasis: Basis

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(components)):
		if i < 1:
			continue #fixed stage should not be jointed to fixed stage
		#Creates joints that connect the moving stages to the fixed stage
		var joint := JoltSliderJoint3D.new()
		add_child(joint)
		joint.rotation_degrees = Vector3(0, 0, 90)
		joint.limit_enabled = true
		joint.limit_upper = maxHeight
		joint.limit_lower = 0.0
		joint.enabled = true
		joint.motor_max_force = 100
		joint.exclude_nodes_from_collision = false
		joint.solver_position_iterations = 200
		joint.solver_velocity_iterations = 100
		joint.position = components[-1].position
		joint.node_a = components[0].get_path()
		joint.node_b = components[i].get_path()
		joints.append(joint)

	joints[-1].motor_enabled = true
	joints[-1].motor_target_velocity = 0.0
	
	initalOffset = components[-1].global_position - components[0].global_position
	initialRotation = components[0].global_rotation
	jointInitialBasis = joints[-1].global_basis


func _physics_process(delta: float) -> void:
	var rotationDelta := components[0].global_rotation - initialRotation
	var tempJointInitialBasis = jointInitialBasis.rotated(Vector3.UP, rotationDelta.y)
	tempJointInitialBasis = tempJointInitialBasis.rotated(Vector3.RIGHT, rotationDelta.x)
	tempJointInitialBasis = tempJointInitialBasis.rotated(Vector3.BACK, rotationDelta.z)
	var axis = rotateThing(jointInitialBasis, rotationDelta).orthonormalized().x
	
	var positionDelta := components[-1].global_position - components[0].global_position - Vector3(rotateThing(initalOffset, rotationDelta))
	
	currentHeight = positionDelta.project(axis).length()
	var error = targetHeight - currentHeight
	if abs(error) > tolorence:
		joints[-1].motor_target_velocity = 5.0 * error
		atTargetHeight = false
	else:
		joints[-1].motor_target_velocity = 0
		atTargetHeight = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func rotateThing(thing, rotationVector):
	var tempThing = thing.rotated(Vector3.UP, rotationVector.y)
	tempThing = tempThing.rotated(Vector3.RIGHT, rotationVector.x)
	tempThing = tempThing.rotated(Vector3.BACK, rotationVector.z)
	return tempThing
