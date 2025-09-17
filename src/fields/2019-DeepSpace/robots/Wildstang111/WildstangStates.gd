class_name WildstangStates extends Node


const intakeAngles: Dictionary = {
	"Store" : 0.0,
	"HatchIntake" : 0.0,
	"CargoIntake" : 35.0
}

const elevatorHeights: Dictionary = {
	"Store" : 0.0,
	"HatchIntake" : 0.0,
	"CargoShip" : 0.1,
	"RocketMiddle" : 0.24,
	"RocketHigh" : 0.49
}

const latervatorHeights: Dictionary = {
	"Store" : 0.0,
	"HatchIntake" : 0.0,
	"HatchScore" : 0.1
}

const climberAngles: Dictionary = {
	"Store" : 80,
	"Climb" : -40
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
		robotNode.elevator.targetHeight = elevatorHeights["Store"]
		robotNode.groundIntake.targetAngle = intakeAngles["Store"]
		robotNode.latervator.targetHeight = latervatorHeights["Store"]
		robotNode.climber.targetAngle = climberAngles["Store"]
		robotNode.groundIntakeArea.enabled = false
		robotNode.manipulatorCargoIntake.enabled = true
	
	func executeFunc(delta: float):
		if robotNode.passthorughDetector.containsPiece():
			robotNode.passThroughArea.enabled = true
		else:
			robotNode.passThroughArea.enabled = false


class CargoIntakeState extends BaseState:
	func _init(wildstangNode: Wildstang) -> void:
		super("CargoIntake", wildstangNode)
	
	func initFunc():
		robotNode.elevator.targetHeight = elevatorHeights["Store"]
		robotNode.groundIntake.targetAngle = intakeAngles["CargoIntake"]
		robotNode.latervator.targetHeight = latervatorHeights["Store"]
		robotNode.manipulatorCargoIntake.enabled = true
	
	func executeFunc(delta: float):
		if robotNode.groundIntake.atTargetAngle and robotNode.elevator.atPosition:
			robotNode.groundIntakeArea.enabled = true
			robotNode.passThroughArea.enabled = true
		if robotNode.passthorughDetector.containsPiece():
			robotNode.statemachine.requestState(StoreState.new(robotNode))
	
	func exitFunc():
		robotNode.groundIntake.targetAngle = intakeAngles["Store"]
		robotNode.groundIntakeArea.enabled = false
	
	func requirements():
		return not (robotNode.hasHatch or robotNode.hasCargo)


class HatchIntakeState extends BaseState:
	func _init(wildstangNode: Wildstang) -> void:
		super("HatchIntake", wildstangNode)
	
	func initFunc():
		robotNode.elevator.targetHeight = elevatorHeights["HatchIntake"]
		robotNode.groundIntake.targetAngle = intakeAngles["HatchIntake"]
		robotNode.latervator.targetHeight = latervatorHeights["HatchIntake"]
	
	func requirements():
		return not (robotNode.hasHatch or robotNode.hasCargo)


class CargoShipState extends BaseState:
	func _init(wildstangNode: Wildstang) -> void:
		super("CargoShip", wildstangNode)
	
	func initFunc():
		robotNode.elevator.targetHeight = elevatorHeights["CargoShip"]


class ScoreHatchPannel extends BaseState:
	var time: float = 0.0
	func _init(wildstangNode: Wildstang) -> void:
		super("ScoreHatch", wildstangNode)
	
	func initFunc():
		robotNode.latervator.targetHeight = latervatorHeights["HatchScore"]
	
	func executeFunc(delta: float):
		time += delta
		#print(time)
		if time > 0.5:
			robotNode.hasHatch = false
			robotNode.hatch.freeze = false
			robotNode.hatch.collision_layer = 20
			robotNode.hatch.collision_mask = 1+2+4+16
			robotNode.hatch.reparent(robotNode.get_tree().root.get_node("GameWorld/2019-Field"))
			var force = Vector3(0,0,0.0).rotated(Vector3.UP, robotNode.hatch.global_rotation.y)
			robotNode.hatch.apply_central_impulse(force)
			robotNode.statemachine.requestState(StoreState.new(robotNode))
			robotNode.get_node("hatchLatervator/latervator/FakeHatch").disabled = true
	
	func requirements():
		return robotNode.hasHatch


class RocketMiddleState extends BaseState:
	func _init(wildstangNode: Wildstang) -> void:
		super("RocketMiddleState", wildstangNode)
	
	func initFunc():
		robotNode.elevator.targetHeight = elevatorHeights["RocketMiddle"]
		robotNode.groundIntake.targetAngle = intakeAngles["Store"]
		robotNode.latervator.targetHeight = latervatorHeights["Store"]


class RocketHighState extends BaseState:
	func _init(wildstangNode: Wildstang) -> void:
		super("RocketHighState", wildstangNode)
	
	func initFunc():
		robotNode.elevator.targetHeight = elevatorHeights["RocketHigh"]
		robotNode.groundIntake.targetAngle = intakeAngles["Store"]
		robotNode.latervator.targetHeight = latervatorHeights["Store"]


class ClimbState extends BaseState:
	func _init(wildstangNode: Wildstang) -> void:
		super("ClimbState", wildstangNode)
	
	func initFunc():
		robotNode.elevator.targetHeight = elevatorHeights["Store"]
		robotNode.groundIntake.targetAngle = intakeAngles["Store"]
		robotNode.latervator.targetHeight = latervatorHeights["Store"]
		robotNode.climber.targetAngle = climberAngles["Climb"]
