class_name Spartan971 extends Robot


var states: SpartanStates = SpartanStates.new(self)
var statemachine: StateMachine

@onready var elevator: ContinuousElevator = $elevator
@onready var arm: Arm = $MultiArm
@onready var hatchIntake: HatchSnap = $MultiArm/ArmBody/SnapIntake
@onready var cargoIntake: CargoIntake = $FrontRollerBody/CargoIntake
@onready var cargoArm: Arm = $frontBars
@onready var cargoSnap: CargoSnap = $MultiArm/ArmBody/CargoSnap
#@onready var leftStilt: ContinuousElevator = $LeftStiltElevator
#@onready var rightStilt: ContinuousElevator = $RightStiltElevator
#@onready var leftFootArm: Arm = $leftFootArm
#@onready var rightFootArm: Arm = $rightFootArm
@onready var lightMesh1: MeshInstance3D = $drivebase/flippedLightMesh
@onready var lightMesh2: MeshInstance3D = $drivebase/flippedLightMesh2

var redMaterial := StandardMaterial3D.new()
var greenMaterial := StandardMaterial3D.new()

var flipArm: bool = false:
	set(val):
		flipArm = val
		if flipArm:
			lightMesh1.set_surface_override_material(0, redMaterial)
			lightMesh2.set_surface_override_material(0, greenMaterial)
		else:
			lightMesh1.set_surface_override_material(0, greenMaterial)
			lightMesh2.set_surface_override_material(0, redMaterial)

var hasHatch := false:
	set(val):
		hasHatch = val
var hasCargo := false

var climbIndex: int = 0

func _ready() -> void:
	super._ready()
	hasHatch = true
	drivetrain.enabled = true
	statemachine = StateMachine.new(states.extendedStore)
	add_child(statemachine)
	
	hatchIntake.hasObject.connect(func(): hasHatch = true)
	hatchIntake.lostObject.connect(func(): hasHatch = false)
	
	cargoSnap.hasObject.connect(func(): hasCargo = true)
	cargoSnap.lostObject.connect(func(): hasCargo = false)
	
	redMaterial.albedo_color = Color(1.0, 0.0, 0.0)
	redMaterial.emission_enabled = true
	redMaterial.emission_energy_multiplier = 16.0
	redMaterial.emission = Color(1.0, 0.0, 0.0)
	greenMaterial.albedo_color = Color(0.0, 1.0, 0.0)
	greenMaterial.emission = Color(0.0, 1.0, 0.0)
	greenMaterial.emission_energy_multiplier = 16.0
	greenMaterial.emission_enabled = true


func removePieces():
	if not cargoSnap.objectBody == null:
		cargoSnap.connectionJoint.queue_free()
		cargoSnap.objectBody.queue_free()
		hasCargo = false
	if not hatchIntake.objectBody == null:
		hatchIntake.connectionJoint.queue_free()
		hatchIntake.objectBody.queue_free()
		hasHatch = false


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	#print(rightStilt.currentHeight)
	if scoreboard.currentGameState != scoreboard.gameStates.NotStarted:
		enableRequired(delta)


func enableRequired(delta: float) -> void:
	
	if Input.is_action_just_pressed("intakeHatch"):
		statemachine.requestState(states.hatchIntake)
	elif Input.is_action_just_released("intakeHatch"):
		statemachine.requestState(states.store)
	
	if Input.is_action_just_pressed("RocketLow"):
		if statemachine.currentState == states.hatchLow:
			statemachine.requestState(states.store)
		else:
			statemachine.requestState(states.hatchLow)
	
	if Input.is_action_just_pressed("RocketMid"):
		if statemachine.currentState == states.hatchMid:
			statemachine.requestState(states.store)
		else:
			statemachine.requestState(states.hatchMid)
	
	if Input.is_action_just_pressed("RocketHigh"):
		if statemachine.currentState == states.hatchHigh:
			statemachine.requestState(states.store)
		else:
			statemachine.requestState(states.hatchHigh)
	
	if Input.is_action_just_pressed("ShipHeight"):
		if statemachine.currentState == states.cargoShip:
			statemachine.requestState(states.store)
		else:
			statemachine.requestState(states.cargoShip)
	
	if Input.is_action_just_pressed("cargoIntake"):
		statemachine.requestState(states.cargoIntake)
	elif Input.is_action_just_released("cargoIntake"):
		statemachine.requestState(states.store)
	
	if Input.is_action_just_released("flip"):
		flipArm = !flipArm
	
	if Input.is_action_just_pressed("Eject"):
		if hasHatch:
			hatchIntake.eject()
			statemachine.requestState(states.store)
		elif hasCargo:
			cargoSnap.eject()
			statemachine.requestState(states.store)
	
	#if Input.is_action_just_pressed("climb"):
		#climbIndex += 1
		#if climbIndex == 1:
			#statemachine.requestState(states.climbExtend)
		#elif climbIndex == 2:
			#statemachine.requestState(states.climbFolded)


func scoreClimb() -> void:
	for body in drivetrain.get_colliding_bodies():
		if body.name == "carpetCollide":
			return
	
	for body in drivetrain.get_colliding_bodies():
		if body.get_parent().name == "habFloor":
			scoreboard.scoreClimb(1, "Blue")
			return
	
	for body in drivetrain.get_colliding_bodies():
		if body.name == "l2Climb":
			scoreboard.scoreClimb(2, "Blue")
			return
	
	for body in drivetrain.get_colliding_bodies():
		if body.name == "l3Climb":
			scoreboard.scoreClimb(3, "Blue")
			return
	
	print(drivetrain.get_colliding_bodies())


func updateStart(location: int, startingGP: String, ISBLUE: bool, cameraIndex:int = -1):
	if hasHatch and hatchIntake.objectBody == null:
		hasHatch = false
	
	
	isBlue = ISBLUE
	startingIndex = location
	#starting location
	match location:
		0:
			global_position = Vector3(1.105, 0.114, -6.5) 
		1:
			global_position = Vector3(0.0, 0.114, -6.5)
		2:
			global_position = Vector3(-1.105, 0.114, -6.5)
		3:
			global_position = Vector3(1.105, 0.231, -7.779)
		4:
			global_position = Vector3(-1.105, 0.231, -7.779)
	rotation_degrees.y = 0
	
	#adjust for alliance
	if not isBlue:
		global_position.z *= -1.0
		rotation_degrees.y = 180.0
	
	#add correct cameraView
	if cameraIndex != -1:
		if cameraIndex > 1:
			swapCam()
		if cameraIndex % 2 == 1:
			invertCam()
		currentCameraIndex = cameraIndex
	
	#remove any preloads
	if not cargoSnap.objectBody == null:
		cargoSnap.connectionJoint.queue_free()
		cargoSnap.objectBody.queue_free()
		hasCargo = false
	if not hatchIntake.objectBody == null:
		hatchIntake.connectionJoint.queue_free()
		hatchIntake.objectBody.queue_free()
		hasHatch = false
	
	#add correct preload
	if startingGP == "Cargo":
		var cargo = preload("res://src/fields/2019-DeepSpace/gamePieces/cargo.tscn").instantiate()
		fieldNode.add_child(cargo)
		cargoSnap.snap(cargo)
	else:
		var hatch := preload("res://src/fields/2019-DeepSpace/gamePieces/HatchPanel.tscn").instantiate()
		hatch.rotation_degrees.x = 90.0
		fieldNode.add_child(hatch)
		hatch.global_position = hatchIntake.global_position + Vector3(0,0,0.1)
		hatchIntake.snap(hatch)
	
	startingIndex = location
	preloadGP = startingGP
	statemachine.requestState(states.store)
