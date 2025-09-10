class_name Wildstang extends Robot


@onready var groundIntake: Arm = $CargoGroundIntakeArm
@onready var groundIntakeArea: IntakeArea = $SwerveBase/groundIntakeArea
@onready var passThroughArea: IntakeArea = $SwerveBase/passthroughArea
@onready var passthorughDetector: IntakeArea = $SwerveBase/PassthroughDetector
@onready var manipulatorCargoIntake: IntakeArea = $CascadeElevator/manipulator/ManipulatorCargoIntake
@onready var manipulatorCargoBlocker: CollisionShape3D = $CascadeElevator/manipulator/cargoBlocker
@onready var mainpCargoDetector: IntakeArea = $CascadeElevator/manipulator/ManipCargoDetector
@onready var elevator: CascadeElevator = $CascadeElevator
@onready var latervator: CascadeElevator = $hatchLatervator


@onready var statemachine: StateMachine = StateMachine.new(WildstangStates.StoreState.new(self))

var hasHatch := false
var hatch: HatchPanel

var hasCargo := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	add_child(statemachine)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if scoreboard.currentEnableState == scoreboard.enableStates.Enabled:
		processEnabled()
	
	if hasHatch:
		hatch.global_position = $hatchLatervator/latervator/HatchIntake.global_position
		hatch.rotation.x = 0
		hatch.rotation.y = 0


func processEnabled():
	if Input.is_action_just_pressed("cargoIntake"):
		statemachine.requestState(WildstangStates.CargoIntakeState.new(self))
	elif Input.is_action_just_released("cargoIntake"):
		statemachine.requestState(WildstangStates.StoreState.new(self))
	
	if Input.is_action_just_pressed("Eject"):
		if hasHatch:
			statemachine.requestState(WildstangStates.ScoreHatchPannel.new(self))
		else:
			manipulatorCargoBlocker.disabled = true
	elif Input.is_action_just_released("Eject"):
		manipulatorCargoBlocker.disabled = false
	
	if Input.is_action_just_pressed("ShipHeight"):
		if statemachine.currentState is WildstangStates.CargoShipState:
			statemachine.requestState(WildstangStates.StoreState.new(self))
		else:
			statemachine.requestState(WildstangStates.CargoShipState.new(self))
	
	if Input.is_action_just_pressed("RocketMid"):
		if statemachine.currentState is WildstangStates.RocketMiddleState:
			statemachine.requestState(WildstangStates.StoreState.new(self))
		else:
			statemachine.requestState(WildstangStates.RocketMiddleState.new(self))
	
	if Input.is_action_just_pressed("RocketHigh"):
		if statemachine.currentState is WildstangStates.RocketHighState:
			statemachine.requestState(WildstangStates.StoreState.new(self))
		else:
			statemachine.requestState(WildstangStates.RocketHighState.new(self))
	
	if Input.is_action_just_pressed("intakeHatch"):
		statemachine.requestState(WildstangStates.HatchIntakeState.new(self))
	elif Input.is_action_just_released("intakeHatch"):
		statemachine.requestState(WildstangStates.StoreState.new(self))
	
	if Input.is_action_just_pressed("RocketLow"):
		statemachine.requestState(WildstangStates.StoreState.new(self))


func _on_hatch_intake_area_entered(area: Area3D) -> void:
	if statemachine.currentState is WildstangStates.HatchIntakeState and area.get_parent() is HatchPanel:
		hatch = area.get_parent()
		hasHatch = true
		hatch.reparent($hatchLatervator/latervator)
		hatch.freeze = true
		hatch.global_position = $hatchLatervator/latervator/HatchIntake.global_position
		hatch.rotation.x = 0
		hatch.collision_layer = 0
		hatch.collision_mask = 0


func _on_manip_cargo_detector_body_entered(body: Node3D) -> void:
	if body is Cargo:
		hasCargo = true


func _on_manip_cargo_detector_body_exited(body: Node3D) -> void:
	if body is Cargo:
		hasCargo = false


func _on_hatch_intake_area_exited(area: Area3D) -> void:
	if area.name == "inHabZone" and hasHatch:
		$hatchLatervator/latervator/FakeHatch.disabled = false
		print("ran")
