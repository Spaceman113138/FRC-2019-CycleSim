class_name Madtown extends Node3D

const cargoIntakeStore := 70.0

@onready var cargoIntake: Arm = $CargoIntake
@onready var cargoIntakeRollers: Intake = $CargoIntake/groundIntake
@onready var elevator: ContinuousElevator = $ContinuousElevator
@onready var CargoManipulator: Intake = $ContinuousElevator/Carrage
@onready var Latervator: ContinuousElevator = $Latervator
@onready var hatchIntake: Intake = $Latervator/Latervator2
@onready var hatchCollider: CollisionShape3D = $Latervator/Latervator2/FakeHatchCollider
@onready var swerveDrive: SwerveBase = $SwerveBase

var scoreboard: DeepSpaceScorecard

var hasCargo := false
var hasHatchPannel := false:
	set(val):
		hasHatchPannel = val
		hatchCollider.disabled = not val
var hatchPanel: HatchPanel

@onready var stateMachine: StateMachine = StateMachine.new(MadtownStates.StoreState.new(self))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreboard = get_tree().root.get_node("Node3D/2019-Field/2019Scorecard")
	scoreboard.Enable.connect(func(): swerveDrive.enabled = true)
	scoreboard.Disable.connect(func(): swerveDrive.enabled = false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if scoreboard.currentEnableState == scoreboard.enableStates.Enabled:
		enableRequireProcess()
	
	if hasHatchPannel:
		hatchPanel.global_position = $Latervator/Latervator2/HatchIntake.global_position
		hatchPanel.rotation.x = 0
		hatchPanel.rotation.y = 0


func enableRequireProcess():
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
			var force = Vector3(0,0,0.5).rotated(Vector3.UP, hatchPanel.global_rotation.y)
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

func _on_intaking_collider_body_entered(body: Node3D) -> void:
	if body is Cargo and not hasHatchPannel and not hasCargo:
		cargoIntakeRollers.active = false
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
