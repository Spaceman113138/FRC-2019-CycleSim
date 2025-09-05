class_name CargoShip extends Node3D

@export var bay1StartsHatch: bool = true
@export var bay2StartsHatch: bool = true
@export var bay3StartsHatch: bool = true

@onready var wingRight: Sprite3D = $CargoShip/wingRight
@onready var wingLeft: Sprite3D = $CargoShip/wingLeft
@onready var lowerRight: Sprite3D = $CargoShip/lowerRight
@onready var lowerLeft: Sprite3D = $CargoShip/lowerLeft
@onready var midRight: Sprite3D = $CargoShip/midRight
@onready var midLeft: Sprite3D = $CargoShip/midLeft
@onready var mesh: MeshInstance3D = $CargoShip
@onready var autoHolder: StaticBody3D = $AutoCargoHold
var scorecard: DeepSpaceScorecard

var blueWingRight := preload("res://assets/field/2019-DeepSpace/materials/ge-19082-right-blue.png")
var blueWingLeft := preload("res://assets/field/2019-DeepSpace/materials/ge-19082-left-blue.png")
var blueLowerRight := preload("res://assets/field/2019-DeepSpace/materials/ge-19079-right-blue.png")
var blueLowerLeft := preload("res://assets/field/2019-DeepSpace/materials/ge-19079-left-blue.png")
var blueMidRight := preload("res://assets/field/2019-DeepSpace/materials/ge-19080-right-blue.png")
var blueMidLeft := preload("res://assets/field/2019-DeepSpace/materials/ge-19080-left-blue.png")
var blueMaterial := preload("res://assets/field/2019-DeepSpace/materials/blue.tres")

var cargoScene := preload("res://assets/field/2019-DeepSpace/gamePieces/cargo.tscn")

var cargoStartSpots = {
	"bayFrontLeft" : Vector3(-0.265, 0.721, 2.311),
	"bayFrontRight" : Vector3(0.265, 0.721, 2.311),
	"bay1Left" : Vector3(-0.481, 0.721, 1.62),
	"bay1Right" : Vector3(0.481, 0.721, 1.62),
	"bay2Left" : Vector3(-0.481, 0.721, 1.054),
	"bay2Right" : Vector3(0.481, 0.721, 1.054),
	"bay3Left" : Vector3(-0.481, 0.721, 0.497),
	"bay3Right" : Vector3(0.481, 0.721, 0.497),
}

var createdCargo: Array[Cargo] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scorecard = get_tree().root.get_node("GameWorld/2019-Field/2019Scorecard")
	scorecard.TeleopStart.connect(disableAutoCollsiion)
	
	if global_position.z < 0:
		wingRight.texture = blueWingRight
		wingLeft.texture = blueWingLeft
		lowerRight.texture = blueLowerRight
		lowerLeft.texture = blueLowerLeft
		midRight.texture = blueMidRight
		midLeft.texture = blueMidLeft
		mesh.set_surface_override_material(1, blueMaterial)
		mesh.set_surface_override_material(3, blueMaterial)
	
	var cargoLocations = [cargoStartSpots["bayFrontLeft"],cargoStartSpots["bayFrontRight"]]
	if not bay1StartsHatch:
		cargoLocations.append_array([cargoStartSpots["bay1Left"],cargoStartSpots["bay1Right"]])
	else:
		get_node("Bay1Left").addStartingHatch()
		get_node("Bay1Right").addStartingHatch()
	if not bay2StartsHatch:
		cargoLocations.append_array([cargoStartSpots["bay2Left"],cargoStartSpots["bay2Right"]])
	else:
		get_node("Bay2Left").addStartingHatch()
		get_node("Bay2Right").addStartingHatch()
	if not bay3StartsHatch:
		cargoLocations.append_array([cargoStartSpots["bay3Left"],cargoStartSpots["bay3Right"]])
	else:
		get_node("Bay3Left").addStartingHatch()
		get_node("Bay3Right").addStartingHatch()
	
	for location in cargoLocations:
		var newCargo: Cargo = cargoScene.instantiate()
		add_child(newCargo)
		newCargo.position = location
		createdCargo.append(newCargo)


func disableAutoCollsiion():
	get_node("AutoCargoHold/front").disabled = true
	get_node("AutoCargoHold/Left").disabled = true
	get_node("AutoCargoHold/right").disabled = true
	
	for cargo in createdCargo:
		cargo.sleeping = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
