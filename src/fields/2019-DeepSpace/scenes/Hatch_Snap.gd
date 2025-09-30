class_name HatchSnap extends SnapIntake


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func snap(body: Node3D):
	#body.rotation.y = 0
	#body.rotation.x = 0
	super.snap(body)
	body.detectable = false


func eject():
	objectBody.detectable = true
	super.eject()


func _on_body_entered(body: Node3D) -> void:
	if objectBody == null and body is HatchPanel and body.collision_layer == 20 and body.freeze == false and enabled and body.is_inside_tree():
		snap(body)
