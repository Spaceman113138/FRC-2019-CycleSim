class_name AlgeaIntake extends Area3D

var contacts: Array[RigidBody3D] = []
@export var forceAmount: float = 15
@export var enabled: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var vector = Vector3(0,0,1)
	
	#print(global_rotation_degrees)
	
	vector = vector.rotated(Vector3(1,0,0), global_rotation.x)
	vector = vector.rotated(Vector3(0,1,0), global_rotation.y)
	vector = vector.rotated(Vector3(0,0,1), global_rotation.z)
	#print(vector)
	
	for body in contacts:
		body.apply_central_force(vector * forceAmount * int(enabled))
		


func _on_body_entered(body: Node3D) -> void:
	if body is Cargo:
		contacts.append(body)


func _on_body_exited(body: Node3D) -> void:
	if body is Cargo and contacts.has(body):
		contacts.remove_at(contacts.find(body))
