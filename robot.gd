class_name SwerveDrive extends RigidBody3D

@export var WIDTH: float = 0.6096 #26 inches to meters
@export var HEIGHT: float = 0.6096

# Z+ forward | X+ left
@onready var modulePositions: Array[Vector3] = [
	Vector3(WIDTH / 2.0, 0, HEIGHT / 2.0), #FL module
	Vector3(-WIDTH / 2.0, 0, HEIGHT / 2.0), #FR module
	Vector3(-WIDTH / 2.0, 0, -HEIGHT / 2.0), #BR module
	Vector3(WIDTH / 2.0, 0, -HEIGHT / 2.0) #BL module
]


func _physics_process(delta: float) -> void:
	var desiredTranslateForce := Vector3.ZERO
	var desiredRotation: float = 0 #1 = CW, -1 = CCW
	if Input.is_key_label_pressed(KEY_W):
		desiredTranslateForce += Vector3.BACK
	if Input.is_key_label_pressed(KEY_S):
		desiredTranslateForce += Vector3.FORWARD
	if Input.is_key_label_pressed(KEY_A):
		desiredTranslateForce += Vector3.RIGHT
	if Input.is_key_label_pressed(KEY_D):
		desiredTranslateForce += Vector3.LEFT
	if Input.is_key_label_pressed(KEY_J):
		desiredRotation += -1
	if Input.is_key_label_pressed(KEY_L):
		desiredRotation += 1
	
	desiredTranslateForce = desiredTranslateForce.normalized()
	
	for i in range(4):
		apply_force(calculateModuleForce(i, modulePositions[i], desiredTranslateForce, desiredRotation), modulePositions[i])



func calculateModuleForce(i: int, modulePos: Vector3, desiredTranslateForce: Vector3, desiredRotateForce: float):
	var translateForce = desiredTranslateForce
	translateForce = translateForce.rotated(Vector3.UP, rotation.y)
	var twoDimPos = Vector2(modulePos.x, modulePos.z)
	var rotateDirection = (twoDimPos.orthogonal().normalized()) * -desiredRotateForce #create perp vec
	var rotateForce = Vector3(rotateDirection.x, 0, rotateDirection.y)
	var combinedForce = (translateForce + rotateForce).normalized()
	return combinedForce * 450
