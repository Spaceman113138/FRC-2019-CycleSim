extends Area3D

@onready var hatchScene := preload("res://assets/field/2019-DeepSpace/HatchPanel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var hasHatch := false
	for thing in get_overlapping_areas():
		if thing.get_parent() is HatchPanel:
			hasHatch = true
			break
	
	if not hasHatch:
		var newHatch: HatchPanel = hatchScene.instantiate()
		get_parent().add_child(newHatch)
		newHatch.position = Vector3(0.301, 1.675, 0.019)
		newHatch.reparent(get_tree().root.get_node("Node3D/2019-Field"))
