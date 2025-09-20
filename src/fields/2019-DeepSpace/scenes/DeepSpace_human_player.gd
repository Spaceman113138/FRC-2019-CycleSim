class_name DeepSpaceHP extends Node3D

@onready var hatchScene := preload("res://src/fields/2019-DeepSpace/gamePieces/HatchPanel.tscn")
@onready var cargoScene := preload("res://src/fields/2019-DeepSpace/gamePieces/cargo.tscn")
@onready var hatchDetectionArea: Area3D = $Area3D

var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var hasHatch := false
	for thing in hatchDetectionArea.get_overlapping_areas():
		if thing.get_parent() is HatchPanel:
			hasHatch = true
			break
	
	if not hasHatch:
		var newHatch: HatchPanel = hatchScene.instantiate()
		add_child(newHatch)
		newHatch.position = Vector3(0.301, 1.675, 0.019)
		newHatch.reparent(get_tree().root.get_node("GameWorld/2019-Field"))
		timer = 1.0
	
	timer += delta


func dropCargo() -> void:
	if timer > 2.0:
		var newCargo: Cargo = cargoScene.instantiate()
		add_child(newCargo)
		newCargo.position = Vector3(0.021, 1.165, -0.177)
		newCargo.reparent(get_tree().root.get_node("GameWorld/2019-Field"))
		timer = 0.0
