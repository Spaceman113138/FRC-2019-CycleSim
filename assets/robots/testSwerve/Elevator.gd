class_name ContinuousElevator extends Node3D


@export var components: Array[RigidBody3D]
var joints: Array[JoltSliderJoint3D]

var currentHeight: float = 0
var targetHeight: float = 0.0
@export var tolorence: float = 0.01
@export var maxHeight: float = 1.5
var atTargetHeight: bool = true


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
		joint.enabled = true
		joint.motor_max_force = 30
		joint.exclude_nodes_from_collision = false
		joint.solver_position_iterations = 50
		joint.solver_velocity_iterations = 50
		joint.position = components[0].position
		joint.node_a = components[0].get_path()
		joint.node_b = components[i].get_path()
		joints.append(joint)

	joints[-1].motor_enabled = true
	joints[-1].motor_target_velocity = 0.0


func _physics_process(delta: float) -> void:
	currentHeight = components[-1].position.y - components[0].position.y
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
