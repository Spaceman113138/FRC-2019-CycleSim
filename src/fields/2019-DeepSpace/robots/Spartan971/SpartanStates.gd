class_name SpartanStates extends Node

const ElevatorHeights := {
	"Store" : 0.0,
	"HatchStore" : 0.4,
	"HatchIntake" : 0.05,
	"HatchLow" : 0.0,
	"HatchMid" : 0.70,
	"HatchHigh" : 1.43
}

const ArmAngles := {
	"Store" : 0.0,
	"HatchStore" : 0.0,
	"HatchIntake" : 90.0,
	"HatchLow" : 90.0,
	"HatchMid" : 90.0,
	"HatchHigh" : 90.0
}


var store: StoreState
var hatchIntake: HatchIntakeState
var hatchLow: ScoreHatchLowState
var hatchMid: ScoreHatchMidState
var hatchHigh: ScoreHatchHighState

func _init(RobotNode: Spartan971) -> void:
	store = StoreState.new(RobotNode)
	hatchIntake = HatchIntakeState.new(RobotNode)
	hatchLow = ScoreHatchLowState.new(RobotNode)
	hatchMid = ScoreHatchMidState.new(RobotNode)
	hatchHigh = ScoreHatchHighState.new(RobotNode)


class BaseState extends State:
	var robotNode: Spartan971
	
	func setSuperstructureTargets(targetState: String, flipped: bool):
		robotNode.elevator.targetHeight = ElevatorHeights[targetState]
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
	
	func executeFunc(delta: float):
		if robotNode.hasHatch:
			robotNode.elevator.targetHeight = ElevatorHeights["HatchStore"]
			if robotNode.elevator.atTargetHeight:
				robotNode.arm.targetAngle = ElevatorHeights["HatchStore"]
		else:
			setSuperstructureTargets("Store", false)


class HatchIntakeState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "HatchIntakeState")
	
	func requirements():
		return not robotNode.hasHatch
	
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


class ScoreHatchLowState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "HatchScoreLowState")
	
	func requirements():
		return robotNode.hasHatch
	
	func executeFunc(delta: float):
		setSuperstructureTargets("HatchLow", robotNode.flipArm)


class ScoreHatchMidState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "HatchScoreMidState")
	
	func requirements():
		return robotNode.hasHatch
	
	func executeFunc(delta: float):
		setSuperstructureTargets("HatchMid", robotNode.flipArm)


class ScoreHatchHighState extends BaseState:
	func _init(RobotNode: Spartan971) -> void:
		super._init(RobotNode, "HatchScoreHighState")
	
	func requirements():
		return robotNode.hasHatch
	
	func executeFunc(delta: float):
		setSuperstructureTargets("HatchHigh", robotNode.flipArm)
