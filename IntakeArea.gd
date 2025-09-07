class_name IntakeArea extends Area3D


var contacts: Array[RigidBody3D] = []
@export var forceAmount: float = 15
@export var enabled: bool = true
@export var reversed: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func containsPiece() -> bool:
	return len(contacts) > 0


func _physics_process(delta: float) -> void:
	if not enabled:
		return
	var vector = Vector3(0,0,1)
	if reversed:
		vector *= -1
	
	#print(global_rotation_degrees)
	
	vector = vector.rotated(Vector3(1,0,0), global_rotation.x)
	vector = vector.rotated(Vector3(0,1,0), global_rotation.y)
	vector = vector.rotated(Vector3(0,0,1), global_rotation.z)
	#print(vector)
	
	for body in contacts:
		body.apply_central_force(vector * forceAmount * int(enabled))
