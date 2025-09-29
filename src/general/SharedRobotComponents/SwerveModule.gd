class_name SwerveModule extends CollisionHolder

@export var mesh: MeshInstance3D
@export var ray: RayCast3D

var modulePosition: Vector3
var rotationDirection: Vector3
var forceVector: Vector3 = Vector3.ZERO

func _ready():
	super._ready()
	modulePosition = position
	var flatModulePosition = Vector3(modulePosition.x, 0, modulePosition.z)
	rotationDirection = flatModulePosition.rotated(Vector3.UP, deg_to_rad(90)).normalized()


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
