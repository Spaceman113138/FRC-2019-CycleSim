class_name Arm extends Node3D

@export var armJoint: JoltHingeJoint3D

@export var angleOffset: float = 0
@export var tolorence: float = 2.5
var currentAngle: float = 0
@export var targetAngle: float = 0
var atTargetAngle: bool = 0

@export var P: float = 1
@export var useLimits := false
@export var armBody: RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	armJoint.position = position
	var scoreboard: DeepSpaceScorecard = get_tree().root.get_node("GameWorld/2019-Field/2019Scorecard")
	scoreboard.Disable.connect(func(): armJoint.motor_enabled = false)
	scoreboard.Enable.connect(func(): armJoint.motor_enabled = true)

func _physics_process(delta: float) -> void:
	if useLimits:
		armJoint.limit_lower = deg_to_rad(targetAngle)
		armJoint.limit_upper = deg_to_rad(targetAngle)
	else:
		currentAngle = armBody.rotation_degrees.x + angleOffset
		print(currentAngle)
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
