class_name Wildstang extends Robot


@onready var groundIntake: Arm = $CargoGroundIntakeArm
@onready var groundIntakeArea: IntakeArea = $SwerveBase/groundIntakeArea
@onready var passThroughArea: IntakeArea = $SwerveBase/passthroughArea
@onready var passthorughDetector: IntakeArea = $SwerveBase/PassthroughDetector
@onready var manipulatorCargoIntake: IntakeArea = $CascadeElevator/manipulator/ManipulatorCargoIntake
@onready var manipulatorCargoBlocker: CollisionShape3D = $CascadeElevator/manipulator/cargoBlocker
@onready var mainpCargoDetector: IntakeArea = $CascadeElevator/manipulator/ManipCargoDetector


@onready var statemachine: StateMachine = StateMachine.new(WildstangStates.StoreState.new(self))

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


func processEnabled():
	if Input.is_action_just_pressed("cargoIntake"):
		statemachine.requestState(WildstangStates.CargoIntakeState.new(self))
	elif Input.is_action_just_released("cargoIntake"):
		statemachine.requestState(WildstangStates.StoreState.new(self))
	
	if Input.is_action_just_pressed("Eject"):
		manipulatorCargoBlocker.disabled = true
		print("clicked")
	elif Input.is_action_just_released("Eject"):
		manipulatorCargoBlocker.disabled = false
