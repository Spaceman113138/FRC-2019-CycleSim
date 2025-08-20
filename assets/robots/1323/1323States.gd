class_name MadtownStates extends Node

enum Heights {Stow, Ship, RocketLow, RocketMid, RocketHigh}
const heightValues = {
	Heights.Stow : 0.0,
	Heights.Ship : 0.5,
	Heights.RocketLow : 0.15,
	Heights.RocketMid : 0.85,
	Heights.RocketHigh : 1.6,
}

enum CargoInakeAngles {Stow, Intaking, IntakeMid}
const intakeAngles = {
	CargoInakeAngles.Stow : 75,
	CargoInakeAngles.Intaking : 0,
	CargoInakeAngles.IntakeMid : 45
}

class BaseState extends State:
	var MadtownNode: Madtown

	func _init(stateName: String, madtownNode: Madtown) -> void:
		super(stateName)
		MadtownNode = madtownNode


class StoreState extends BaseState:
	func _init(madtown: Madtown) -> void:
		super("Store", madtown)

	func initFunc():
		MadtownNode.elevator.targetHeight = heightValues[Heights.Stow]
		MadtownNode.cargoIntake.targetAngle = intakeAngles[CargoInakeAngles.Stow]
		MadtownNode.cargoIntakeRollers.active = false
		MadtownNode.CargoManipulator.active = true


class IntakeCargo extends BaseState:
	func _init(madtown: Madtown) -> void:
		super("Intake Cargo", madtown)
	
	func initFunc():
		MadtownNode.elevator.targetHeight = heightValues[Heights.Stow]
		MadtownNode.cargoIntake.targetAngle = intakeAngles[CargoInakeAngles.Intaking]
		MadtownNode.cargoIntakeRollers.active = true
		MadtownNode.CargoManipulator.active = true
	
	func requirements():
		return not (MadtownNode.hasCargo or MadtownNode.hasHatchPannel)


class IntakeCargoMid extends BaseState:
	func _init(madtown: Madtown) -> void:
		super("Intake Cargo Mid", madtown)
	
	func initFunc():
		MadtownNode.elevator.targetHeight = heightValues[Heights.Stow]
		MadtownNode.cargoIntake.targetAngle = intakeAngles[CargoInakeAngles.IntakeMid]
		MadtownNode.cargoIntakeRollers.active = true
		MadtownNode.CargoManipulator.active = true


class CargoShipHeight extends BaseState:
	func _init(madtown: Madtown) -> void:
		super("CargoShipHeight", madtown)
	
	func initFunc():
		MadtownNode.elevator.targetHeight = heightValues[Heights.Ship]
		MadtownNode.cargoIntake.targetAngle = intakeAngles[CargoInakeAngles.Stow]
		MadtownNode.cargoIntakeRollers.active = false
		MadtownNode.CargoManipulator.active = true


class CargoRocketLow extends BaseState:
	func _init(madtown: Madtown) -> void:
		super("CargoRocketLow", madtown)
		
	func initFunc():
		MadtownNode.elevator.targetHeight = heightValues[Heights.RocketLow]
		MadtownNode.cargoIntake.targetAngle = intakeAngles[CargoInakeAngles.Stow]
		MadtownNode.cargoIntakeRollers.active = false
		MadtownNode.CargoManipulator.active = true


class CargoRocketMid extends BaseState:
	func _init(madtown: Madtown) -> void:
		super("CargoRocketMid", madtown)
	
	func initFunc():
		MadtownNode.elevator.targetHeight = heightValues[Heights.RocketMid]
		MadtownNode.cargoIntake.targetAngle = intakeAngles[CargoInakeAngles.Stow]
		MadtownNode.cargoIntakeRollers.active = false
		MadtownNode.CargoManipulator.active = true


class CargoRocketHigh extends BaseState:
	func _init(madtown: Madtown) -> void:
		super("CargoRocketHigh", madtown)
	
	func initFunc():
		MadtownNode.elevator.targetHeight = heightValues[Heights.RocketHigh]
		MadtownNode.cargoIntake.targetAngle = intakeAngles[CargoInakeAngles.Stow]
		MadtownNode.cargoIntakeRollers.active = false
		MadtownNode.CargoManipulator.active = true
