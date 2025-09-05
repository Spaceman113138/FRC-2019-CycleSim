extends Node3D

@onready var hatchScene := preload("res://assets/field/2019-DeepSpace/gamePieces/HatchPanel.tscn")
@onready var cargoScene := preload("res://assets/field/2019-DeepSpace/gamePieces/cargo.tscn")
@onready var hatchDetectionArea: Area3D = $Area3D
var robotNode: Node3D

var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	robotNode = get_tree().root.get_node("GameWorld/1323/SwerveBase")


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
	
	if Input.is_action_just_pressed("CargoDrop") and timer > 2.0:
		if sign(robotNode.global_position.x) == sign(global_position.x):
			var newCargo: Cargo = cargoScene.instantiate()
			add_child(newCargo)
			newCargo.position = Vector3(0.021, 1.165, -0.177)
			newCargo.reparent(get_tree().root.get_node("GameWorld/2019-Field"))
			timer = 0.0
	
	timer += delta
