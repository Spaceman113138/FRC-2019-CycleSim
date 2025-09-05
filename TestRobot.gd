class_name TestBot extends Node3D

@export var drivebase:SwerveBase

#@onready var camera: Camera3D = $Camera3D

@onready var elevator := $ContinuousElevator
@onready var arm := $Arm

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#for child in get_children():
		#for youngerChild in child.get_children():
			#if youngerChild is CollisionShape3D:
				#youngerChild.reparent(self)


func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_P):
		elevator.targetHeight = 0.75
	else:
		elevator.targetHeight = 0.0
	
	if Input.is_key_pressed(KEY_Q):
		arm.targetAngle = -90
	elif Input.is_key_pressed(KEY_E):
		arm.targetAngle = 90
	else:
		arm.targetAngle = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#camera.position = getPosition() + Vector3(0,0.75,-1.5)


func getPosition() -> Vector3:
	return drivebase.position
