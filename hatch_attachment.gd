class_name HatchAttachment extends Area3D

var hatchPannel: HatchPanel
var scorecard: DeepSpaceScorecard

signal scored

var color: String
var location: String

var field: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scorecard = get_tree().root.get_node("Node3D/2019-Field/2019Scorecard")
	field = get_tree().root.get_node("Node3D/2019-Field")
	
	color = "Blue" if global_position.z < 0 else "Red"
	if global_position.x < -3.5:
		location = "Left"
	elif global_position.x > 3.5:
		location = "Right"
	else:
		location = "Middle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if hatchPannel == null:
		for area in get_overlapping_areas():
			if area.get_parent() is HatchPanel and area.get_parent().freeze == false:
				hatchPannel = area.get_parent()
				hatchPannel.freeze = true
				hatchPannel.global_rotation.x = global_rotation.x
				hatchPannel.global_position.y = global_rotation.y
				hatchPannel.global_position.z = global_rotation.z
				hatchPannel.global_position = global_position
				hatchPannel.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
				if scorecard.currentGameState != scorecard.gameStates.AfterMatch:
					scorecard.addHatchPannel(2, color, location)
					scored.emit()
				
	else:
		hatchPannel.global_rotation.x = global_rotation.x
		hatchPannel.global_position.y = global_rotation.y
		hatchPannel.global_position.z = global_rotation.z
		hatchPannel.global_position = global_position

func addStartingHatch():
	var hatchScene := preload("res://assets/field/2019-DeepSpace/gamePieces/HatchPanel.tscn")
	hatchPannel = hatchScene.instantiate()
	add_child(hatchPannel)
	hatchPannel.freeze = true
	hatchPannel.global_rotation.x = global_rotation.x
	hatchPannel.global_position.y = global_rotation.y
	hatchPannel.global_position.z = global_rotation.z
	hatchPannel.global_position = global_position
	hatchPannel.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	hatchPannel.reparent.call_deferred(field)
