class_name Robot extends Node3D

@export var drivetrain: SwerveBase
@export var firstPersonCam: Camera3D
@export var thirdPersonCam: Camera3D

@export var bumperMesh: Array[MeshInstance3D]

var bumperMaterial: StandardMaterial3D = StandardMaterial3D.new()

@onready var cameraTransform: Vector3 = Vector3.ZERO:
	set(val):
		cameraTransform = val
		drivetrain.fieldOrientOffset = -thirdPersonCam.rotation.y

var scoreboard: DeepSpaceScorecard
var fieldNode: Node3D
var isBlue := true:
	set(val):
		isBlue = val
		if isBlue:
			bumperMaterial.albedo_color = Color.MEDIUM_BLUE
		else:
			bumperMaterial.albedo_color = Color.RED

var startingIndex: int = 0
var currentCameraIndex: int = 0
var preloadGP: String

var logo := preload("res://icon.svg")
var logoScaleFactor: Vector2 = Vector2(1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreboard = get_tree().root.get_node("GameWorld/2019-Field/2019Scorecard")
	fieldNode = get_tree().root.get_node("GameWorld/2019-Field")
	scoreboard.Enable.connect(func(): drivetrain.enabled = true)
	scoreboard.SandstormStart.connect(func(): drivetrain.enabled = true)
	scoreboard.Disable.connect(func(): drivetrain.enabled = false)
	cameraTransform = thirdPersonCam.position
	
	for mesh in bumperMesh:
		for i in range(mesh.get_surface_override_material_count()):
			mesh.set_surface_override_material(i, bumperMaterial)
	
	bumperMaterial.albedo_color = Color.PURPLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	thirdPersonCam.global_position = drivetrain.global_position + cameraTransform


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("swapCameraDirection"):
		invertCam()
		if currentCameraIndex % 2 == 0:
			currentCameraIndex += 1
		else:
			currentCameraIndex -= 1
	
	if Input.is_action_just_pressed("swapCameraView"):
		swapCam()
		currentCameraIndex = (currentCameraIndex + 2) % 4

func invertCam():
	thirdPersonCam.rotation.y *= -1.0
	cameraTransform.x *= -1.0
	thirdPersonCam.position = cameraTransform
	
	firstPersonCam.rotation.y += PI
	firstPersonCam.position.z *= -1.0
	
	drivetrain.invert = not drivetrain.invert

func swapCam():
	#print("ranThisThing")
	thirdPersonCam.current = not thirdPersonCam.current
	drivetrain.FIELD_ORIENT = not drivetrain.FIELD_ORIENT


func updateStart(location: int, startingGP: String, ISBLUE: bool, cameraIndex:int = -1):
	return


func getPosition() -> Vector3:
	return drivetrain.global_position

#Returns Radians!!!!!!!
func getRotationRads() -> Vector3:
	return drivetrain.global_rotation


func getRotationDegs() -> Vector3:
	return drivetrain.global_rotation_degrees
