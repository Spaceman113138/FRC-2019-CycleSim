class_name Arm extends Node3D

@export var armJoint: JoltHingeJoint3D

@export var angleOffset: float = 0
@export var tolorence: float = 2.5
var currentAngle: float = 0
var targetAngle: float = 0
var atTargetAngle: bool = 0

@onready var armBody: RigidBody3D = $arm


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	armJoint.position = position


func _physics_process(delta: float) -> void:
	currentAngle = armBody.rotation_degrees.z + angleOffset
	var error = currentAngle - targetAngle
	
	if abs(error) > tolorence:
		atTargetAngle = false
		armJoint.motor_target_velocity = 1 * error
	else:
		atTargetAngle = true
		armJoint.motor_target_velocity = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
