class_name Arm extends Node3D

var setup := false

@export var armJoint: JoltHingeJoint3D

@export var angleOffset: float = 0
@export var tolorence: float = 2.5
var currentAngle: float = 0
@export var targetAngle: float = 0:
	set(val):
		targetAngle = val
		if setup:
			_physics_process(0.0)

var atTargetAngle: bool = false

@export var P: float = 1
@export var useLimits := false
@export var continuousRotation := true
@export var armBody: RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	armJoint.position = position
	var scoreboard: DeepSpaceScorecard = get_tree().root.get_node("GameWorld/2019-Field/2019Scorecard")
	scoreboard.Disable.connect(func(): armJoint.motor_enabled = false)
	scoreboard.Enable.connect(func(): armJoint.motor_enabled = true)
	
	setup = true

func _physics_process(delta: float) -> void:
	if useLimits:
		var target := targetAngle
		if not continuousRotation:
			target = move_toward(rad_to_deg(armJoint.limit_lower), targetAngle, 30.0)
		armJoint.limit_lower = deg_to_rad(target)
		armJoint.limit_upper = deg_to_rad(target)
		
	else:
		currentAngle = armBody.rotation_degrees.x + angleOffset
		var error = targetAngle - currentAngle
		if abs(error) > tolorence:
			atTargetAngle = false
			armJoint.motor_target_velocity = P * error
		else:
			atTargetAngle = true
			armJoint.motor_target_velocity = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
