class_name Madtown extends Robot

const cargoIntakeStore := 70.0

@onready var cargoIntake: Arm = $CargoIntake
@onready var cargoIntakeRollers: Intake = $CargoIntake/groundIntake
@onready var elevator: ContinuousElevator = $ContinuousElevator
@onready var CargoManipulator: Intake = $ContinuousElevator/Carrage
@onready var Latervator: ContinuousElevator = $Latervator
@onready var hatchIntake: Intake = $Latervator/Latervator2
@onready var hatchCollider: CollisionShape3D = $Latervator/Latervator2/FakeHatchCollider
@onready var swerveDrive: SwerveBase = $SwerveBase


var hasCargo := false
var hasHatchPannel := false:
	set(val):
		hasHatchPannel = val
		hatchCollider.disabled = not val
var hatchPanel: HatchPanel

@onready var stateMachine: StateMachine = StateMachine.new(MadtownStates.StoreState.new(self))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	thirdPersonCam.global_position = swerveDrive.global_position + cameraTransform


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
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
			hatchPanel.reparent(get_tree().root.get_node("GameWorld/2019-Field"))
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


func setUpStart(location: int, startingGP: String, ISBLUE: bool):
	isBlue = ISBLUE
	startingIndex = location
	match location:
		0:
			global_position = Vector3(1.105, 0.079, -6.604) 
		1:
			global_position = Vector3(0.0, 0.079, -6.604)
		2:
			global_position = Vector3(-1.105, 0.079, -6.604)
		3:
			global_position = Vector3(1.105, 0.231, -7.779)
		4:
			global_position = Vector3(-1.105, 0.231, -7.779)
	
	if not isBlue:
		global_position *= Vector3(1.0, 1.0, -1.0)
		rotation_degrees.y = 180.0
	
	if startingGP == "Cargo":
		var newCargo = preload("res://assets/field/2019-DeepSpace/gamePieces/cargo.tscn").instantiate()
		add_child(newCargo)
		newCargo.position = Vector3(0.0, 0.573, 0.1)
		newCargo.reparent(fieldNode)
	else:
		var hatch = preload("res://assets/field/2019-DeepSpace/gamePieces/HatchPanel.tscn").instantiate()
		hasHatchPannel = true
		$Latervator/Latervator2.add_child(hatch)
		hatch.freeze = true
		hatch.global_position = $Latervator/Latervator2/HatchIntake.global_position
		hatch.rotation.x = 0
		hatchPanel = hatch
	
	stateMachine.requestState(MadtownStates.StoreState.new(self))



func _on_intaking_collider_body_entered(body: Node3D) -> void:
	if body is Cargo and not hasHatchPannel and not hasCargo and stateMachine.currentState == MadtownStates.IntakeCargo:
		cargoIntakeRollers.active = false
		stateMachine.requestState(MadtownStates.IntakeCargoMid.new(self))


func _on_intaking_collider_body_exited(body: Node3D) -> void:
	if body is Cargo:
		stateMachine.requestState(MadtownStates.StoreState.new(self))


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


func _on_cargo_detector_body_entered(body: Node3D) -> void:
	if body is Cargo:
		hasCargo = true


func _on_cargo_detector_body_exited(body: Node3D) -> void:
	if body is Cargo:
		hasCargo = false
