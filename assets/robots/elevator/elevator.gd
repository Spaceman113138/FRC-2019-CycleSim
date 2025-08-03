extends Node3D

@onready var staticNode = $StaticBody3D
@onready var moveNode = $elevatorMoving



func _physics_process(delta: float) -> void:
	print(staticNode.position.y - moveNode.position.y)
