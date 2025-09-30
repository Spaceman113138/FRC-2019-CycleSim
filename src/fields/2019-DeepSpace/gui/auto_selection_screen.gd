extends Control


@onready var preloadHatchButton := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PreloadButtons/Hatch
@onready var selectionButton := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/StartingOptions
@onready var marginContainer := $MarginContainer
@onready var cameraSelect := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/cameraOptions

var wildstang := preload("res://src/fields/2019-DeepSpace/robots/Wildstang111/wildstang_111.tscn")
var spartans := preload("res://src/fields/2019-DeepSpace/robots/Spartan971/spartan_971.tscn")

var gameWorld := preload("res://src/general/GameWorld.tscn")
@onready var world: Node3D = gameWorld.instantiate()
@onready var camera: Camera3D = world.get_node("Camera3D")
@onready var field = world.get_node("2019-Field")
@onready var scorecard: DeepSpaceScorecard = field.get_node("2019Scorecard")
@onready var blueCargoShip: CargoShip = field.get_node("BlueCargoShip")
@onready var redCargoShip: CargoShip = field.get_node("RedCargoShip")

var robotNode: Robot
var isBlue := true
var preloadCargo := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	get_tree().root.add_child.call_deferred(world)
	addRobot(wildstang)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func addRobot(resource: PackedScene):
	if robotNode != null:
		robotNode.removePieces()
		robotNode.queue_free()
	
	robotNode = resource.instantiate()
	world.add_child(robotNode)
	call_deferred("updateRobot")


func updateRobot() -> void:
	if get_tree().paused == false:
		get_tree().paused = true
		call_deferred("updateRobot")
	else:
		robotNode.updateStart(
			selectionButton.selected, 
			"Hatch" if preloadHatchButton.button_pressed else "Cargo", isBlue)
		get_tree().paused = false


func _on_bay_1_hatch_pressed() -> void:
	if blueCargoShip.bay1StartsHatch == false:
		blueCargoShip.bay1StartsHatch = true
		blueCargoShip.setBay1("Hatch")
		redCargoShip.bay1StartsHatch = true
		redCargoShip.setBay1("Hatch")


func _on_bay_1_cargo_pressed() -> void:
	if blueCargoShip.bay1StartsHatch == true:
		blueCargoShip.bay1StartsHatch = false
		blueCargoShip.setBay1("Cargo")
		redCargoShip.bay1StartsHatch = false
		redCargoShip.setBay1("Cargo")


func _on_bay_2_hatch_pressed() -> void:
	if blueCargoShip.bay2StartsHatch == false:
		blueCargoShip.bay2StartsHatch = true
		blueCargoShip.setBay2("Hatch")
		redCargoShip.bay2StartsHatch = true
		redCargoShip.setBay2("Hatch")


func _on_bay_2_cargo_pressed() -> void:
	if blueCargoShip.bay2StartsHatch == true:
		blueCargoShip.bay2StartsHatch = false
		blueCargoShip.setBay2("Cargo")
		redCargoShip.bay2StartsHatch = false
		redCargoShip.setBay2("Cargo")


func _on_bay_3_hatch_pressed() -> void:
	if blueCargoShip.bay3StartsHatch == false:
		blueCargoShip.bay3StartsHatch = true
		blueCargoShip.setBay3("Hatch")
		redCargoShip.bay3StartsHatch = true
		redCargoShip.setBay3("Hatch")


func _on_bay_3_cargo_pressed() -> void:
	if blueCargoShip.bay3StartsHatch == true:
		blueCargoShip.bay3StartsHatch = false
		blueCargoShip.setBay3("Cargo")
		redCargoShip.bay3StartsHatch = false
		redCargoShip.setBay3("Cargo")


func _on_starting_options_item_selected(index: int) -> void:
	updateRobot()


func _on_button_pressed() -> void:
	if isBlue:
		redCargoShip.bay1StartsHatch = true
		redCargoShip.bay2StartsHatch = true
		redCargoShip.bay3StartsHatch = true
		redCargoShip.setBay1("Hatch")
		redCargoShip.setBay2("Hatch")
		redCargoShip.setBay3("Hatch")
	else:
		blueCargoShip.bay1StartsHatch = true
		blueCargoShip.bay2StartsHatch = true
		blueCargoShip.bay3StartsHatch = true
		blueCargoShip.setBay1("Hatch")
		blueCargoShip.setBay2("Hatch")
		blueCargoShip.setBay3("Hatch")
	
	camera.queue_free()
	
	robotNode.firstPersonCam.current = true
	if cameraSelect.selected > 1:
		robotNode.swapCam()
		robotNode.drivetrain.FIELD_ORIENT = true
	else:
		robotNode.drivetrain.FIELD_ORIENT = false
	if cameraSelect.selected % 2 == 0:
		robotNode.invertCam()
	
	scorecard.visible = true
	scorecard.waitToStart = false
	
	get_tree().paused = false
	
	get_tree().root.get_node("AutoSelectionScreen").call_deferred("free")


func _on_blue_pressed() -> void:
	if isBlue == false:
		isBlue = true
		camera.global_position.z = -0.1
		camera.rotation_degrees.y = -28.1
		marginContainer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT, true)
		updateRobot()


func _on_red_pressed() -> void:
	if isBlue == true:
		isBlue = false
		camera.global_position.z *= 0.1
		camera.rotation_degrees.y += -90.0 - 28.1
		marginContainer.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT, true)
		updateRobot()


func _on_hatch_pressed() -> void:
	preloadCargo = false
	updateRobot()


func _on_cargo_pressed() -> void:
	preloadCargo = true
	updateRobot()


func _on_robot_option_item_selected(index: int) -> void:
	if index == 0:
		addRobot(wildstang)
	else:
		addRobot(spartans)
