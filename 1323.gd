class_name Madtown extends Node3D

const cargoIntakeStore := 70.0

@onready var cargoIntake := $CargoIntake
@onready var algeaStop := $ContinuousElevator/Carrage/AlgeaStop
@onready var elevator := $ContinuousElevator

enum Heights {Stow, Ship, RocketLow, RocketMid, RocketHigh}
const heightValues = {
	Heights.Stow : 0.0,
	Heights.Ship : 0.5,
	Heights.RocketLow : 0.15,
	Heights.RocketMid : 0.85,
	Heights.RocketHigh : 1.6,
}
var currentHeight = Heights.Stow:
	set(val):
		currentHeight = val
		elevator.targetHeight = heightValues[val]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("cargoIntake"):
		cargoIntake.targetAngle = 0
		currentHeight = Heights.Stow
	elif Input.is_action_just_released("cargoIntake"):
		cargoIntake.targetAngle = cargoIntakeStore

	if Input.is_action_just_pressed("Eject"):
		algeaStop.disabled = true
	elif Input.is_action_just_released("Eject"):
		algeaStop.disabled = false
	
	if Input.is_action_just_pressed("ShipHeight"):
		if currentHeight == Heights.Ship:
			currentHeight = Heights.Stow
		else:
			currentHeight = Heights.Ship
	elif Input.is_action_just_pressed("RocketLow"):
		if currentHeight == Heights.RocketLow:
			currentHeight = Heights.Stow
		else:
			currentHeight = Heights.RocketLow
	elif Input.is_action_just_pressed("RocketMid"):
		if currentHeight == Heights.RocketMid:
			currentHeight = Heights.Stow
		else:
			currentHeight = Heights.RocketMid
	elif Input.is_action_just_pressed("RocketHigh"):
		if currentHeight == Heights.RocketHigh:
			currentHeight = Heights.Stow
		else:
			currentHeight = Heights.RocketHigh

func _on_intaking_collider_body_entered(body: Node3D) -> void:
	if body is Cargo:
		cargoIntake.targetAngle = 45
		print("setAngle")

func _on_intaking_collider_body_exited(body: Node3D) -> void:
	if body is Cargo:
		cargoIntake.targetAngle = cargoIntakeStore
