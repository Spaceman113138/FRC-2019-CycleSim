class_name Robot extends Node3D

@export var drivetrain: SwerveBase
@export var firstPersonCam: Camera3D
@export var thirdPersonCam: Camera3D

@onready var cameraTransform: Vector3 = Vector3.ZERO:
	set(val):
		cameraTransform = val
		drivetrain.fieldOrientOffset = -thirdPersonCam.rotation.y

var scoreboard: DeepSpaceScorecard
var fieldNode: Node3D
var isBlue := true
var startingIndex: int = 0

var logo := preload("res://icon.svg")
var logoScaleFactor: Vector2 = Vector2(1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreboard = get_tree().root.get_node("GameWorld/2019-Field/2019Scorecard")
	fieldNode = get_tree().root.get_node("GameWorld/2019-Field")
	scoreboard.Enable.connect(func(): drivetrain.enabled = true)
	scoreboard.Disable.connect(func(): drivetrain.enabled = false)
	cameraTransform = thirdPersonCam.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	thirdPersonCam.global_position = drivetrain.global_position + cameraTransform


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("swapCameraDirection"):
		thirdPersonCam.rotation.y *= -1.0
		cameraTransform.x *= -1.0
		thirdPersonCam.position = cameraTransform
		
		firstPersonCam.rotation.y += PI
		firstPersonCam.position.z *= -1.0
		
		drivetrain.invert = not drivetrain.invert
	
	if Input.is_action_just_pressed("swapCameraView"):
		thirdPersonCam.current = !thirdPersonCam.current
		drivetrain.FIELD_ORIENT = !drivetrain.FIELD_ORIENT


func updateStart(location: int, startingGP: String, ISBLUE: bool):
	return
