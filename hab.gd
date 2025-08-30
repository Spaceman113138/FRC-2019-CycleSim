extends Node3D

@onready var rightMesh: MeshInstance3D = $rightCargoHolder
@onready var leftMesh: MeshInstance3D = $leftCargoHolder
@onready var floor: MeshInstance3D = $habFloor
@onready var hab: MeshInstance3D = $hab

var redMesh := preload("res://assets/field/2019-DeepSpace/materials/red.tres")
var darkerRedMesh := preload("res://assets/field/2019-DeepSpace/materials/darkerRed.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global_position.z > 0:
		for i in range(rightMesh.get_surface_override_material_count()):
			rightMesh.set_surface_override_material(i, redMesh)
		
		for i in range(leftMesh.get_surface_override_material_count()):
			leftMesh.set_surface_override_material(i, redMesh)
		
		for i in range(floor.get_surface_override_material_count()):
			if i == 1 or i == 3 or i == 4:
				floor.set_surface_override_material(i, darkerRedMesh)
			else:
				floor.set_surface_override_material(i, redMesh)
		
		for i in range(hab.get_surface_override_material_count()):
			if i == 1 or i == 7 or i == 9:
				hab.set_surface_override_material(i, redMesh)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
