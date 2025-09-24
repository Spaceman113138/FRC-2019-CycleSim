class_name SnapIntake extends Area3D

signal hasObject
signal lostObject

var objectBody: RigidBody3D
var bodyTransform: Vector3
var connectionJoint: JoltGeneric6DOFJoint3D
@export var enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func eject():
	objectBody = null
	connectionJoint.queue_free()
	lostObject.emit()


func snap(body: RigidBody3D):
	var joint := JoltGeneric6DOFJoint3D.new()
	joint.solver_position_iterations = 200
	joint.solver_velocity_iterations = 400
	joint.node_a = get_parent().get_path()
	joint.node_b = body.get_path()
	get_parent().add_child(joint)
	
	objectBody = body
	connectionJoint = joint 
	
	hasObject.emit()
