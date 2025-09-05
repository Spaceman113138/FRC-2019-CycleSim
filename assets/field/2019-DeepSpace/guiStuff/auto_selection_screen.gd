extends Control


@onready var bay1RightSprite = $HBoxContainer/MarginContainer2/bay1Right
@onready var bay2RightSprite = $HBoxContainer/MarginContainer2/bay2Right
@onready var bay3RightSprite = $HBoxContainer/MarginContainer2/bay3Right
@onready var bay1LeftSprite = $HBoxContainer/MarginContainer2/bay1Left
@onready var bay2LeftSprite = $HBoxContainer/MarginContainer2/bay2Left
@onready var bay3LeftSprite = $HBoxContainer/MarginContainer2/bay3Left

var hatchImage := preload("res://assets/field/2019-DeepSpace/materials/hatchPannel.png")
var cargoImage := preload("res://assets/field/2019-DeepSpace/materials/cargoImage.svg")
var blueImage := preload("res://assets/field/2019-DeepSpace/materials/blueAutoSelector.png")
var redImage := preload("res://assets/field/2019-DeepSpace/materials/redAutoSelector.png")

var gameWorld := preload("res://GameWorld.tscn")
@onready var world = gameWorld.instantiate()
@onready var field = world.get_node("2019-Field")
@onready var cargoShip: CargoShip = field.get_node("BlueCargoShip")
@onready var image := $HBoxContainer/MarginContainer2/TextureRect

@onready var startSprites: Array[Sprite2D] = [
	$HBoxContainer/MarginContainer2/L1Left, $HBoxContainer/MarginContainer2/L1Center,
	$HBoxContainer/MarginContainer2/L1Right, $HBoxContainer/MarginContainer2/L2Left,
	$HBoxContainer/MarginContainer2/L2Right]

var isBlue := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bay_1_hatch_pressed() -> void:
	bay1LeftSprite.texture = hatchImage
	bay1LeftSprite.scale = Vector2(0.049, 0.049)
	bay1RightSprite.texture = hatchImage
	bay1RightSprite.scale = Vector2(0.049, 0.049)
	
	cargoShip.bay1StartsHatch = true


func _on_bay_1_cargo_pressed() -> void:
	bay1LeftSprite.texture = cargoImage
	bay1LeftSprite.scale = Vector2(0.15, 0.15)
	bay1RightSprite.texture = cargoImage
	bay1RightSprite.scale = Vector2(0.15, 0.15)
	
	cargoShip.bay1StartsHatch = false


func _on_bay_2_hatch_pressed() -> void:
	bay2LeftSprite.texture = hatchImage
	bay2LeftSprite.scale = Vector2(0.049, 0.049)
	bay2RightSprite.texture = hatchImage
	bay2RightSprite.scale = Vector2(0.049, 0.049)
	
	cargoShip.bay2StartsHatch = true


func _on_bay_2_cargo_pressed() -> void:
	bay2LeftSprite.texture = cargoImage
	bay2LeftSprite.scale = Vector2(0.15, 0.15)
	bay2RightSprite.texture = cargoImage
	bay2RightSprite.scale = Vector2(0.15, 0.15)
	
	cargoShip.bay2StartsHatch = false


func _on_bay_3_hatch_pressed() -> void:
	bay3LeftSprite.texture = hatchImage
	bay3LeftSprite.scale = Vector2(0.049, 0.049)
	bay3RightSprite.texture = hatchImage
	bay3RightSprite.scale = Vector2(0.049, 0.049)
	
	cargoShip.bay3StartsHatch = true


func _on_bay_3_cargo_pressed() -> void:
	bay3LeftSprite.texture = cargoImage
	bay3LeftSprite.scale = Vector2(0.15, 0.15)
	bay3RightSprite.texture = cargoImage
	bay3RightSprite.scale = Vector2(0.15, 0.15)
	
	cargoShip.bay3StartsHatch = false


func _on_starting_options_item_selected(index: int) -> void:
	for sprite in startSprites:
		sprite.visible = false
	startSprites[index].visible = true


func _on_button_pressed() -> void:
	var preloadCargo = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/PreloadButtons/Cargo.button_pressed
	get_tree().root.add_child(world)
	world.get_node("1323").setUpStart(
		$HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/StartingOptions.selected, 
		"Cargo" if preloadCargo else "Hatch", isBlue)
	get_tree().root.get_node("AutoSelectionScreen").call_deferred("free")


func _on_blue_pressed() -> void:
	image.texture = blueImage
	image.flip_h = true
	isBlue = true


func _on_red_pressed() -> void:
	image.texture = redImage
	image.flip_h = false
	isBlue = false
