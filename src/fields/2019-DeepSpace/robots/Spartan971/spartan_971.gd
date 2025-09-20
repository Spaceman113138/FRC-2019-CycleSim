class_name Spartan971 extends Robot


func _ready() -> void:
	super._ready()
	drivetrain.enabled = true


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
