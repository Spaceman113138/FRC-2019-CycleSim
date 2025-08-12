class_name SwerveBase extends RigidBody3D

@export var TRANSLATION_MULTIPLIER: float = 400
@export var ROTATION_MULTIPLIER: float = 120
@export var STATIC_ROT_MULTIPLIER: float = 300
@export var MAX_MODULE_FORCE: float = 400

@export var FIELD_ORIENT: bool = true

var modules: Array[SwerveModule] = []

#@onready var parentRobot: RigidBody3D = get_parent()

func _ready() -> void:
	for i in range(4):
		var mesh: MeshInstance3D = get_node("SwerveWheel" + str(i + 1))
		var ray: RayCast3D = get_node("RayCast" + str(i + 1))
		var module = SwerveModule.new(ray.position, mesh, ray)
		modules.append(module)
	
	#parentRobot.angular_damp = 10
	#parentRobot.linear_damp = 1.5
	#parentRobot.mass = 50
	#parentRobot.continuous_cd = true


func _physics_process(delta: float) -> void:
	var joysticVector: Vector2 = Input.get_vector("right", "left", "backward", "forward")
	var translateVector := Vector3(joysticVector.x, 0, joysticVector.y) * TRANSLATION_MULTIPLIER
	translateVector = translateVector.rotated(Vector3.UP, rotation.y)
	
	var rotationAmount = Input.get_action_strength("Clockwise") - Input.get_action_strength("CounterClockwise")
	rotationAmount *= -ROTATION_MULTIPLIER
	
	var highestForce = 0
	for module in modules:
		module.updateForceVector(translateVector, rotationAmount)
		if FIELD_ORIENT:
			module.fieldOrient(rotation.y)
		if module.forceVector.length() > highestForce:
			highestForce = module.forceVector.length()
	
	if highestForce > MAX_MODULE_FORCE:
		for module in modules:
			module.desaturate(highestForce, MAX_MODULE_FORCE)
	
	for module in modules:
		apply_force(module.forceVector, module.modulePosition)
	
	if translateVector.length() < 0.1:
		apply_torque(Vector3.UP * STATIC_ROT_MULTIPLIER * sign(rotationAmount))


class SwerveModule:
	var mesh: MeshInstance3D
	var ray: RayCast3D
	
	var modulePosition: Vector3
	var rotationDirection: Vector3
	var forceVector: Vector3 = Vector3.ZERO
	
	func _init(modulePos: Vector3, meshNode: MeshInstance3D, raycast: RayCast3D) -> void:
		modulePosition = modulePos
		var flatModulePosition = Vector3(modulePosition.x, 0, modulePosition.z)
		rotationDirection = flatModulePosition.rotated(Vector3.UP, deg_to_rad(90)).normalized()
		mesh = meshNode
		ray = raycast
	
	func updateForceVector(desiredTranslationVector: Vector3, desiredRotationForce: float):
		if ray.is_colliding():
			var rotationForce = rotationDirection * desiredRotationForce
			forceVector = rotationForce + desiredTranslationVector
		else:
			forceVector = Vector3.ZERO
		
		var angle = atan2(forceVector.x, forceVector.z)
		mesh.rotation.y = angle
	
	func fieldOrient(robotOrientation: float):
		forceVector = -forceVector.rotated(Vector3.UP, robotOrientation)
	
	func desaturate(highestForce: float, MAX_FORCE: float):
		forceVector = forceVector / highestForce * MAX_FORCE
