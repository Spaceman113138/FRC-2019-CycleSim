class_name Spartan971 extends Robot


var states: SpartanStates = SpartanStates.new(self)
var statemachine: StateMachine

@onready var elevator: ContinuousElevator = $elevator
@onready var arm: Arm = $MultiArm
@onready var hatchIntake: HatchSnap = $MultiArm/ArmBody/SnapIntake

var flipArm: bool = false

var hasHatch := false:
	set(val):
		hasHatch = val

func _ready() -> void:
	super._ready()
	drivetrain.enabled = true
	statemachine = StateMachine.new(states.store)
	add_child(statemachine)
	
	hatchIntake.hasObject.connect(func(): hasHatch = true)
	hatchIntake.lostObject.connect(func(): hasHatch = false)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	
	enableRequired(delta)


func enableRequired(delta: float) -> void:
	
	if Input.is_action_just_pressed("intakeHatch"):
		statemachine.requestState(states.hatchIntake)
	elif Input.is_action_just_released("intakeHatch"):
		statemachine.requestState(states.store)
	
	if Input.is_action_just_pressed("RocketLow"):
		if statemachine.currentState == states.hatchLow:
			statemachine.requestState(states.store)
		else:
			statemachine.requestState(states.hatchLow)
	
	if Input.is_action_just_pressed("RocketMid"):
		if statemachine.currentState == states.hatchMid:
			statemachine.requestState(states.store)
		else:
			statemachine.requestState(states.hatchMid)
	
	if Input.is_action_just_pressed("RocketHigh"):
		if statemachine.currentState == states.hatchHigh:
			statemachine.requestState(states.store)
		else:
			statemachine.requestState(states.hatchHigh)
	
	if Input.is_action_just_released("flip"):
		flipArm = !flipArm
	
	if Input.is_action_just_pressed("Eject"):
		if hasHatch:
			hatchIntake.eject()
			statemachine.requestState(states.store)
