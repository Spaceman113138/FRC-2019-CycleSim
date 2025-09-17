class_name Intake extends RigidBody3D


@export var intakeColliders: Array[IntakeArea]
@export var colliders: Array[CollisionShape3D]

var active: bool = false:
	set(val):
		active = val
		for collider in intakeColliders:
			collider.enabled = true

var collidersActive: bool = false:
	set(val):
		collidersActive = val
		for collider in colliders:
			collider.disabled = !val

var reversed: bool = false:
	set(val):
		reversed = val
		for collider in intakeColliders:
			collider.reversed = reversed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
