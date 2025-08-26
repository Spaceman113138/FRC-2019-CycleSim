class_name Madtown extends Node3D

const cargoIntakeStore := 70.0

@onready var cargoIntake: Arm = $CargoIntake
@onready var cargoIntakeRollers: Intake = $CargoIntake/groundIntake
@onready var elevator: ContinuousElevator = $ContinuousElevator
@onready var CargoManipulator: Intake = $ContinuousElevator/Carrage
@onready var Latervator: ContinuousElevator = $Latervator
@onready var hatchIntake: Intake = $Latervator/Latervator2

var hasCargo := false
var hasHatchPannel := false
var hatchPanel: HatchPanel

@onready var stateMachine: StateMachine = StateMachine.new(MadtownStates.StoreState.new(self))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	#print(Engine.get_frames_per_second())
	#print(stateMachine.currentState.stateName)
	if Input.is_action_just_pressed("cargoIntake"):
		stateMachine.requestState(MadtownStates.IntakeCargo.new(self))
	elif Input.is_action_just_released("cargoIntake"):
		stateMachine.requestState(MadtownStates.StoreState.new(self))
	
	if Input.is_action_just_pressed("intakeHatch"):
		stateMachine.requestState(MadtownStates.IntakeHatch.new(self))
	elif Input.is_action_just_released("intakeHatch"):
		stateMachine.requestState(MadtownStates.StoreState.new(self))

	if Input.is_action_just_pressed("Eject"):
		if hasCargo:
			CargoManipulator.collidersActive = false
		elif hasHatchPannel:
			hatchPanel.freeze = false
			hatchPanel.reparent(get_tree().root.get_node("Node3D/2019-Field"))
			hasHatchPannel = false
			var force = Vector3(0,0,1).rotated(Vector3.UP, hatchPanel.global_rotation.y)
			hatchPanel.apply_central_impulse(force)
	elif Input.is_action_just_released("Eject"):
		CargoManipulator.collidersActive = true
	
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
	
	if hasHatchPannel:
		hatchPanel.global_position = $Latervator/Latervator2/HatchIntake.global_position
		hatchPanel.rotation = Vector3(0,0,0)

func _on_intaking_collider_body_entered(body: Node3D) -> void:
	if body is Cargo and not hasHatchPannel:
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


func _on_hatch_intake_body_entered(body: Node3D) -> void:
	if body is HatchPanel and body != hatchPanel and stateMachine.currentState is MadtownStates.IntakeHatch and hasHatchPannel == false:
		hasHatchPannel = true
		body.reparent($Latervator/Latervator2)
		body.freeze = true
		body.global_position = $Latervator/Latervator2/HatchIntake.global_position
		body.rotation.x = 0
		hatchPanel = body


func _on_hatch_intake_body_exited(body: Node3D) -> void:
	if body is HatchPanel:
		hasHatchPannel = false
