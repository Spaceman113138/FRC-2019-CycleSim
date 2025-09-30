class_name HatchAttachment extends Area3D

var hatchPannel: HatchPanel
var cargo: Cargo
var scorecard: DeepSpaceScorecard

signal scored

var color: String
var location: String

var field: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scorecard = get_tree().root.get_node("GameWorld/2019-Field/2019Scorecard")
	if scorecard == null:
		return
	scorecard.TeleopStart.connect(func(): if cargo != null: cargo.sleeping = false)
	field = get_tree().root.get_node("GameWorld/2019-Field")
	
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
				var desiredPos := getHatchProjPoint(hatchPannel)
				hatchPannel.global_rotation.x = global_rotation.x
				hatchPannel.global_position = desiredPos
				hatchPannel.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
				if scorecard.currentGameState != scorecard.gameStates.AfterMatch:
					scorecard.addHatchPannel(2, color, location)
					scored.emit()
				
	else:
		var desiredPos := getHatchProjPoint(hatchPannel)
		hatchPannel.global_rotation.x = global_rotation.x
		hatchPannel.global_rotation.y = global_rotation.y
		hatchPannel.global_position = desiredPos

#project the hatchLocation onto the plane orthoginal to the main axis of the collsion shape for its desired position
func getHatchProjPoint(hatch) -> Vector3:
	#print(global_position)
	#print(global_rotation)
	#print(hatch.global_position)
	var normalVector := Vector3(0, 0, 1.0)
	normalVector = normalVector.rotated(Vector3.UP, rotation.y)
	var d = -(global_position.x * normalVector.x + global_position.y * normalVector.y + global_position.z * normalVector.z)
	
	var distFromPlane = normalVector.dot(hatch.global_position) + d
	var projPoint = hatch.global_position - (distFromPlane * normalVector)
	return projPoint


func addStartingHatch():
	var hatchScene := preload("res://src/fields/2019-DeepSpace/gamePieces/HatchPanel.tscn")
	hatchPannel = hatchScene.instantiate()
	add_child(hatchPannel)
	hatchPannel.freeze = true
	hatchPannel.global_rotation.x = global_rotation.x
	hatchPannel.global_position = global_position
	hatchPannel.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	hatchPannel.reparent.call_deferred(field)


func removeStartingHatch():
	if hatchPannel != null:
		hatchPannel.queue_free()


func addStartingCargo():
	cargo = preload("res://src/fields/2019-DeepSpace/gamePieces/cargo.tscn").instantiate()
	add_child(cargo)
	cargo.position = Vector3(0.018, .236, -0.373)
	cargo.reparent.call_deferred(get_tree().root.get_node("GameWorld/2019-Field"))


func removeStartingCargo():
	if cargo != null:
		cargo.queue_free()
