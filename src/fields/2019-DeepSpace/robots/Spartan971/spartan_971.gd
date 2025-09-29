class_name Spartan971 extends Robot


var states: SpartanStates = SpartanStates.new(self)
var statemachine: StateMachine

@onready var elevator: ContinuousElevator = $elevator
@onready var arm: Arm = $MultiArm
@onready var hatchIntake: HatchSnap = $MultiArm/ArmBody/SnapIntake
@onready var cargoIntake: CargoIntake = $FrontRollerBody/CargoIntake
@onready var cargoArm: Arm = $frontBars
@onready var cargoSnap: CargoSnap = $MultiArm/ArmBody/CargoSnap
@onready var leftStilt: ContinuousElevator = $LeftStiltElevator
@onready var rightStilt: ContinuousElevator = $RightStiltElevator
@onready var leftFootArm: Arm = $leftFootArm
@onready var rightFootArm: Arm = $rightFootArm

var flipArm: bool = false

var hasHatch := false:
	set(val):
		hasHatch = val

var hasCargo := false
var climbIndex: int = 0

func _ready() -> void:
	super._ready()
	drivetrain.enabled = true
	statemachine = StateMachine.new(states.store)
	add_child(statemachine)
	
	hatchIntake.hasObject.connect(func(): hasHatch = true)
	hatchIntake.lostObject.connect(func(): hasHatch = false)
	
	cargoSnap.hasObject.connect(func(): hasCargo = true)
	cargoSnap.lostObject.connect(func(): hasCargo = false)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	#print(rightStilt.currentHeight)
	
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
	
	if Input.is_action_just_pressed("ShipHeight"):
		if statemachine.currentState == states.cargoShip:
			statemachine.requestState(states.store)
		else:
			statemachine.requestState(states.cargoShip)
	
	if Input.is_action_just_pressed("cargoIntake"):
		statemachine.requestState(states.cargoIntake)
	elif Input.is_action_just_released("cargoIntake"):
		statemachine.requestState(states.store)
	
	if Input.is_action_just_released("flip"):
		flipArm = !flipArm
	
	if Input.is_action_just_pressed("Eject"):
		if hasHatch:
			hatchIntake.eject()
			statemachine.requestState(states.store)
		elif hasCargo:
			cargoSnap.eject()
			statemachine.requestState(states.store)
	
	if Input.is_action_just_pressed("climb"):
		climbIndex += 1
		if climbIndex == 1:
			statemachine.requestState(states.climbExtend)
		elif climbIndex == 2:
			statemachine.requestState(states.climbFolded)
