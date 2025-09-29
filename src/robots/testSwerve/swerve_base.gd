class_name SwerveBase extends RigidBody3D

@export var TRANSLATION_MULTIPLIER: float = 400
@export var ROTATION_MULTIPLIER: float = 120
@export var STATIC_ROT_MULTIPLIER: float = 300
@export var MAX_MODULE_FORCE: float = 400

@export var FIELD_ORIENT: bool = false
@export var invert: bool = false

@export var FL: SwerveModule
@export var FR: SwerveModule
@export var BL: SwerveModule
@export var BR: SwerveModule
var modules: Array[SwerveModule] = []
var enabled: bool = false
var fieldOrientOffset: float = 0.0

#@onready var parentRobot: RigidBody3D = get_parent()

func _ready() -> void:
	modules.append(FL)
	modules.append(FR)
	modules.append(BL)
	modules.append(BR)
	
	#parentRobot.angular_damp = 10
	#parentRobot.linear_damp = 1.5
	#parentRobot.mass = 50
	#parentRobot.continuous_cd = true


func _physics_process(delta: float) -> void:
	if not enabled:
		return
	var joysticVector: Vector2 = Input.get_vector("right", "left", "backward", "forward")
	var translateVector := Vector3(joysticVector.x, 0, joysticVector.y) * TRANSLATION_MULTIPLIER
	if invert and not FIELD_ORIENT:
		translateVector *= -1.0
	if FIELD_ORIENT:
		translateVector = translateVector.rotated(Vector3.UP, fieldOrientOffset)
	else:
		translateVector = translateVector.rotated(Vector3.UP, global_rotation.y)
	
	var rotationAmount = Input.get_action_strength("Clockwise") - Input.get_action_strength("CounterClockwise")
	rotationAmount *= -ROTATION_MULTIPLIER
	
	var highestForce = 0
	for module in modules:
		module.updateForceVector(translateVector, rotationAmount)
		#if FIELD_ORIENT:
			#module.fieldOrient(rotation.y)
		if module.forceVector.length() > highestForce:
			highestForce = module.forceVector.length()
	
	if highestForce > MAX_MODULE_FORCE:
		for module in modules:
			module.desaturate(highestForce, MAX_MODULE_FORCE)
	
	for module in modules:
		var forceVector = module.forceVector
		forceVector = forceVector.rotated(Vector3(1,0,0), rotation.x)
		forceVector = forceVector.rotated(Vector3(0,0,1), rotation.z)
		apply_force(forceVector, module.modulePosition)
	
	if translateVector.length() < 0.1:
		apply_torque(Vector3.UP * STATIC_ROT_MULTIPLIER * sign(rotationAmount))


func _on_area_3d_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
