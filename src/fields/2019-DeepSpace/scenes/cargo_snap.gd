class_name CargoSnap extends SnapIntake


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func snap(body: Node3D):
	super.snap(body)
	connectionJoint.global_position = global_position


func eject():
	super.eject()


func _on_body_entered(body: Node3D) -> void:
	if objectBody == null and body is Cargo and enabled and body.is_inside_tree():
		snap(body)
