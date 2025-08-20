class_name Madtown extends Node3D

const cargoIntakeStore := 70.0

@onready var cargoIntake : Arm = $CargoIntake
@onready var cargoIntakeRollers : Intake = $CargoIntake/groundIntake
@onready var elevator : ContinuousElevator = $ContinuousElevator
@onready var CargoManipulator : Intake = $ContinuousElevator/Carrage

var hasCargo := false
var hasHatchPannel := false

@onready var stateMachine: StateMachine = StateMachine.new(MadtownStates.StoreState.new(self))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	print(Engine.get_frames_per_second())
	#print(stateMachine.currentState.stateName)
	if Input.is_action_just_pressed("cargoIntake"):
		stateMachine.requestState(MadtownStates.IntakeCargo.new(self))
	elif Input.is_action_just_released("cargoIntake"):
		stateMachine.requestState(MadtownStates.StoreState.new(self))

	if Input.is_action_just_pressed("Eject"):
		CargoManipulator.active = false
	elif Input.is_action_just_released("Eject"):
		CargoManipulator.active = true
	
	if Input.is_action_just_pressed("ShipHeight"):
		if stateMachine.currentState is MadtownStates.CargoShipHeight:
			stateMachine.requestState(MadtownStates.StoreState.new(self))
		else:
			stateMachine.requestState(MadtownStates.CargoShipHeight.new(self))
	elif Input.is_action_just_pressed("RocketLow"):
		if stateMachine.currentState is MadtownStates.CargoRocketLow:
			stateMachine.requestState(MadtownStates.StoreState.new(self))
		else:
			stateMachine.requestState(MadtownStates.CargoRocketLow.new(self))
	elif Input.is_action_just_pressed("RocketMid"):
		if stateMachine.currentState is MadtownStates.CargoRocketMid:
			stateMachine.requestState(MadtownStates.StoreState.new(self))
		else:
			stateMachine.requestState(MadtownStates.CargoRocketMid.new(self))
	elif Input.is_action_just_pressed("RocketHigh"):
		if stateMachine.currentState is MadtownStates.CargoRocketHigh:
			stateMachine.requestState(MadtownStates.StoreState.new(self))
		else:
			stateMachine.requestState(MadtownStates.CargoRocketHigh.new(self))

func _on_intaking_collider_body_entered(body: Node3D) -> void:
	if body is Cargo:
		stateMachine.requestState(MadtownStates.IntakeCargoMid.new(self))


func _on_intaking_collider_body_exited(body: Node3D) -> void:
	if body is Cargo:
		stateMachine.requestState(MadtownStates.StoreState.new(self))


func _on_carrage_cargo_intake_body_entered(body: Node3D) -> void:
	if body is Cargo:
		hasCargo = true


func _on_carrage_cargo_intake_body_exited(body: Node3D) -> void:
	if body is Cargo:
		hasCargo = false
