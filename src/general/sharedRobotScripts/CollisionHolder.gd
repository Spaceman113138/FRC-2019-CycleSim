class_name CollisionHolder extends Node3D

@export var TargetParent: RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if TargetParent == null:
		TargetParent = get_parent()
	for child in get_children(true):
		if child is CollisionShape3D:
			child.reparent.call_deferred(TargetParent)
