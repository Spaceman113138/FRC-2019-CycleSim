#@tool
class_name HatchPanel extends RigidBody3D

#@export_tool_button("Generate") var generate = generateCollision
@onready var intakeDetector := $intakeDetector

var detectable := true:
	set(val):
		detectable = val
		if detectable:
			collision_layer = 4 + 16
		else:
			collision_layer = 4
		#intakeDetector.set_deferred("monitorable", detectable)

const outerDiameter := 0.48
const innerDiameter := 0.15

func generateCollision():
	var circleSize = (outerDiameter - innerDiameter) / 4.0
	var circleDist = innerDiameter / 2.0 + circleSize
	for i in range(30):
		var node := CollisionShape3D.new()
		var shape = CylinderShape3D.new()
		node.shape = shape
		shape.radius = circleSize
		shape.height = 0.005
		node.rotation_degrees.x = 90
		node.position = Vector3(cos(deg_to_rad(i * 12)) * circleDist, sin(deg_to_rad(i * 12)) * circleDist, 0)
		#node.rotate_x(rad_to_deg(90))
		add_child(node)
		node.owner = self
		print("added")

		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if global_position.y < 0.005:
		freeze = true
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		collision_mask = 0


func _on_intake_detector_area_entered(area: Area3D) -> void:
	if area is HatchIntake and area.enabled == true:
		collision_mask = 0b0111
