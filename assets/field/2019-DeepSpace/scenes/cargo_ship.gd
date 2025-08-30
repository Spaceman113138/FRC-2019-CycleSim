extends Node3D


@onready var wingRight: Sprite3D = $CargoShip/wingRight
@onready var wingLeft: Sprite3D = $CargoShip/wingLeft
@onready var lowerRight: Sprite3D = $CargoShip/lowerRight
@onready var lowerLeft: Sprite3D = $CargoShip/lowerLeft
@onready var midRight: Sprite3D = $CargoShip/midRight
@onready var midLeft: Sprite3D = $CargoShip/midLeft
@onready var mesh: MeshInstance3D = $CargoShip

var blueWingRight := preload("res://assets/field/2019-DeepSpace/materials/ge-19082-right-blue.png")
var blueWingLeft := preload("res://assets/field/2019-DeepSpace/materials/ge-19082-left-blue.png")
var blueLowerRight := preload("res://assets/field/2019-DeepSpace/materials/ge-19079-right-blue.png")
var blueLowerLeft := preload("res://assets/field/2019-DeepSpace/materials/ge-19079-left-blue.png")
var blueMidRight := preload("res://assets/field/2019-DeepSpace/materials/ge-19080-right-blue.png")
var blueMidLeft := preload("res://assets/field/2019-DeepSpace/materials/ge-19080-left-blue.png")
var blueMaterial := preload("res://assets/field/2019-DeepSpace/materials/blue.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global_position.z < 0:
		wingRight.texture = blueWingRight
		wingLeft.texture = blueWingLeft
		lowerRight.texture = blueLowerRight
		lowerLeft.texture = blueLowerLeft
		midRight.texture = blueMidRight
		midLeft.texture = blueMidLeft
		mesh.set_surface_override_material(1, blueMaterial)
		mesh.set_surface_override_material(3, blueMaterial)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
