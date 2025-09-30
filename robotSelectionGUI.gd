class_name RobotSelectionGUI extends Control


var autoGUI = preload("res://src/fields/2019-DeepSpace/2019_auto_selection_screen.tscn")
var robots: Array[Robot] = []

@onready var optionThing: OptionButton = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/robotOptions

var hasDoneRobots := false

var currentRobotIndex := 0

var targetPos = Vector3(-200, 1, -200)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	autoGUI = autoGUI.instantiate()
	get_tree().root.add_child.call_deferred(autoGUI)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var index = 0
	if hasDoneRobots == false:
		var robotPath := DirAccess.open("res://src/fields/2019-DeepSpace/robots/")
		for dir in robotPath.get_directories():
			if dir.begins_with("N_"):
				continue
			var robotDir := DirAccess.open("res://src/fields/2019-DeepSpace/robots/" + dir)
			var robot: Robot
			for file in robotDir.get_files():
				if file.get_extension() == "tscn":
					robot = load("res://src/fields/2019-DeepSpace/robots/" + dir + "/" + file).instantiate()
					optionThing.add_item(dir)
					index += 1
			robots.append(robot)
		
		hasDoneRobots = true
		optionThing.select(0)
		print(robots)


func _on_robot_options_item_selected(index: int) -> void:
	currentRobotIndex = index
