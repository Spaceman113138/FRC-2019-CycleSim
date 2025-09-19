extends Node3D

var robot: Robot
var field: Node3D

func _ready():
	for node in get_children():
		if node is Robot:
			robot = node
			break
	
	for node in get_children():
		if node.name.contains("Field"):
			field = node
			break


func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("reset"):
		var newField := preload("res://src/fields/2019-DeepSpace/2019_field.tscn").instantiate()
		var newRobot := preload("res://src/fields/2019-DeepSpace/robots/Wildstang111/wildstang_111.tscn").instantiate()
		newField.name = field.name
		remove_child(field)
		field.queue_free()
		field = newField
		add_child(field)
		
		remove_child(robot)
		add_child(newRobot)
		newRobot.updateStart(robot.startingIndex, robot.preloadGP, robot.isBlue, robot.currentCameraIndex)
		robot.queue_free()
		robot = newRobot
		
		var scorecard: DeepSpaceScorecard = field.get_node("2019Scorecard")
		scorecard.visible = true
		scorecard.waitToStart = false
