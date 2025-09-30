class_name SpartanStates extends Node

const ElevatorHeights := {
	"Store" : 0.0,
	"HatchStore" : 0.4,
	"CargoStore" : 0.4,
	"HatchIntake" : 0.05,
	"HatchLow" : 0.0,
	"CargoLow" : 0.35,
	"HatchMid" : 0.70,
	"CargoMid" : 1.1,
	"HatchHigh" : 1.43,
	"CargoHigh" : 1.43,
	"CargoCS" : 0.8,
	"CargoIntake" : 0.6
}

const ArmAngles := {
	"Store" : 0.0,
	"HatchStore" : 0.0,
	"CargoStore" : 0.0,
	"HatchIntake" : 90.0,
	"HatchLow" : 90.0,
	"CargoLow" : 90.0,
	"HatchMid" : 90.0,
	"CargoMid" : 90.0,
	"HatchHigh" : 90.0,
	"CargoHigh" : 60.0,
	"CargoIntake" : -130.0,
	"CargoCS" : 90.0
}

const IntakeAngles := {
	"Store" : -20.0,
	"HatchStore" : -20.0,
	"CargoStore" : -20.0,
	"HatchIntake" : -20.0,
	"HatchLow" : -20.0,
	"HatchMid" : -20.0,
	"HatchHigh" : -20.0,
	"CargoLow" : -20.0,
	"CargoMid" : -20.0,
	"CargoHigh" : -20.0,
	"CargoCS" : -20.0,
	"CargoIntake" : 80.0
}

const stiltExtension := -0.80
const footAngle := 45.0

var store: StoreState
var hatchIntake: HatchIntakeState
var cargoIntake: CargoIntakeState
var hatchLow: ScoreHatchLowState
var hatchMid: ScoreHatchMidState
var hatchHigh: ScoreHatchHighState
var cargoShip: ScoreCSState
var extendedStore: ExtendedStoreState
#var climbExtend: ClimbExtendedState
#var climbFolded: ClimbFoldedState

func _init(RobotNode: Spartan971) -> void:
	store = StoreState.new(RobotNode)
	hatchIntake = HatchIntakeState.new(RobotNode)
	cargoIntake = CargoIntakeState.new(RobotNode)
	hatchLow = ScoreHatchLowState.new(RobotNode)
	hatchMid = ScoreHatchMidState.new(RobotNode)
	hatchHigh = ScoreHatchHighState.new(RobotNode)
	cargoShip = ScoreCSState.new(RobotNode)
	extendedStore = ExtendedStoreState.new(RobotNode)
	#climbExtend = ClimbExtendedState.new(RobotNode)
	#climbFolded = ClimbFoldedState.new(RobotNode)


class BaseState extends State:
	var robotNode: Spartan971
	
	func setSuperstructureTargets(targetState: String, flipped: bool):
		var offset = 0.0 if flipped or robotNode.hasHatch else 0.2
		robotNode.elevator.targetHeight = ElevatorHeights[targetState] - offset
		robotNode.cargoArm.targetAngle = IntakeAngles[targetState]
		if flipped:
			robotNode.arm.targetAngle = -ArmAngles[targetState]
		else:
			robotNode.arm.targetAngle = ArmAngles[targetState]
	
	func _init(RobotNode: Spartan971, StateName: String) -> void:
		super._init(StateName)
		robotNode = RobotNode


class StoreState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "Store")
	
	func initFunc():
		pass
		#robotNode.climbIndex = 0
		#robotNode.leftStilt.targetHeight = 0.0
		#robotNode.rightStilt.targetHeight = 0.0
		#robotNode.leftFootArm.targetAngle = 0.0
		#robotNode.rightFootArm.targetAngle = 0.0
	
	func executeFunc(delta: float):
		if robotNode.hasHatch:
			robotNode.elevator.targetHeight = ElevatorHeights["HatchStore"]
			if robotNode.elevator.atTargetHeight:
				robotNode.arm.targetAngle = ArmAngles["HatchStore"]
				robotNode.cargoArm.targetAngle = IntakeAngles["HatchStore"]
		elif robotNode.hasCargo:
			robotNode.elevator.targetHeight = ElevatorHeights["CargoStore"]
			if robotNode.elevator.atTargetHeight:
				robotNode.arm.targetAngle = ArmAngles["CargoStore"]
				robotNode.cargoArm.targetAngle = IntakeAngles["HatchStore"]
		else:
			setSuperstructureTargets("Store", false)


class ExtendedStoreState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "Store")
	
	func initFunc():
		setSuperstructureTargets("HatchStore", false)



class HatchIntakeState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "HatchIntakeState")
	
	func requirements():
		return not (robotNode.hasHatch or robotNode.hasCargo)
	
	func initFunc():
		robotNode.hatchIntake.enabled = true
		if robotNode.isBlue:
			if abs(robotNode.getRotationDegs().y) <= 90:
				setSuperstructureTargets("HatchIntake", false)
			else:
				setSuperstructureTargets("HatchIntake", true)
		else:
			if abs(robotNode.getRotationDegs().y) <= 90:
				setSuperstructureTargets("HatchIntake", true)
			else:
				setSuperstructureTargets("HatchIntake", false)
	
	func endFunc():
		robotNode.hatchIntake.enabled = false


class CargoIntakeState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "CargoIntakeState")
	
	func requirements():
		return not (robotNode.hasHatch or robotNode.hasCargo)
	
	func initFunc():
		setSuperstructureTargets("CargoIntake", false)
	
	func executeFunc(delta: float) -> void:
		if robotNode.hasCargo:
			robotNode.statemachine.requestState(robotNode.states.store)


class ScoreHatchLowState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "HatchScoreLowState")
	
	func requirements():
		return robotNode.hasHatch or robotNode.hasCargo
		
	func executeFunc(delta: float):
		if robotNode.hasHatch:
			setSuperstructureTargets("HatchLow", robotNode.flipArm)
		else:
			setSuperstructureTargets("CargoLow", robotNode.flipArm)


class ScoreHatchMidState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "HatchScoreMidState")
	
	func requirements():
		return robotNode.hasHatch or robotNode.hasCargo
		
	func executeFunc(delta: float):
		if robotNode.hasHatch:
			setSuperstructureTargets("HatchMid", robotNode.flipArm)
		else:
			setSuperstructureTargets("CargoMid", robotNode.flipArm)


class ScoreHatchHighState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "HatchScoreHighState")
	
	func requirements():
		return robotNode.hasHatch or robotNode.hasCargo
	
	func executeFunc(delta: float):
		if robotNode.hasHatch:
			setSuperstructureTargets("HatchHigh", robotNode.flipArm)
		else:
			setSuperstructureTargets("CargoHigh", robotNode.flipArm)


class ScoreCSState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "ScoreCS")
	
	func requirements():
		return robotNode.hasHatch or robotNode.hasCargo
	
	func executeFunc(delta: float):
		if robotNode.hasHatch:
			setSuperstructureTargets("HatchLow", robotNode.flipArm)
		else:
			setSuperstructureTargets("CargoCS", robotNode.flipArm)


#class ClimbExtendedState extends BaseState:
	#func _init(RobotNode: Spartan971) -> void:
		#super._init(RobotNode, "ClimbExtend")
	#
	#func initFunc():
		#robotNode.leftStilt.targetHeight = stiltExtension
		#robotNode.rightStilt.targetHeight = stiltExtension
		#robotNode.leftFootArm.targetAngle = 0.0
		#robotNode.rightFootArm.targetAngle = 0.0
#
#
#class ClimbFoldedState extends BaseState:
	#func _init(RobotNode: Spartan971) -> void:
		#super._init(RobotNode, "ClimbFold")
	#
	#func initFunc():
		#robotNode.leftStilt.targetHeight = stiltExtension
		#robotNode.rightStilt.targetHeight = stiltExtension
		#robotNode.leftFootArm.targetAngle = footAngle
		#robotNode.rightFootArm.targetAngle = footAngle
