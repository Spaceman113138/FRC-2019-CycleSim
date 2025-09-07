class_name WildstangStates extends Node


const intakeAngles: Dictionary = {
	"Store" : 0.0,
	"CargoIntake" : 35.0
}


class BaseState extends State:
	var robotNode: Wildstang

	func _init(StateName: String, wildstangNode: Wildstang) -> void:
		super(StateName)
		robotNode = wildstangNode


class StoreState extends BaseState:
	func _init(wildstangNode: Wildstang) -> void:
		super("Store", wildstangNode)
	
	func initFunc():
		robotNode.groundIntake.targetAngle = intakeAngles["Store"]
		robotNode.groundIntakeArea.enabled = false
		robotNode.manipulatorCargoIntake.enabled = true
	
	func executeFunc():
		if robotNode.passthorughDetector.containsPiece():
			robotNode.passThroughArea.enabled = true
		else:
			robotNode.passThroughArea.enabled = false


class CargoIntakeState extends BaseState:
	func _init(wildstangNode: Wildstang) -> void:
		super("CargoIntake", wildstangNode)
	
	func initFunc():
		robotNode.groundIntake.targetAngle = intakeAngles["CargoIntake"]
		robotNode.manipulatorCargoIntake.enabled = true
	
	func executeFunc():
		if robotNode.groundIntake.atTargetAngle:
			robotNode.groundIntakeArea.enabled = true
			robotNode.passThroughArea.enabled = true
		if robotNode.passthorughDetector.containsPiece():
			robotNode.statemachine.requestState(StoreState.new(robotNode))
