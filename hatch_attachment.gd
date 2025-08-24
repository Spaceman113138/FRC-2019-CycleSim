class_name HatchAttachment extends Area3D

var hatchPannel: HatchPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if hatchPannel == null:
		for area in get_overlapping_areas():
			if area.get_parent() is HatchPanel and area.get_parent().freeze == false:
				hatchPannel = area.get_parent()
				hatchPannel.freeze = true
				hatchPannel.rotation = rotation
				hatchPannel.global_position = global_position
				hatchPannel.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
				monitoring = false
	else:
		hatchPannel.rotation = rotation
		hatchPannel.global_position = global_position
