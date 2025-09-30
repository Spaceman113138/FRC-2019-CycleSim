class_name Wildstang extends Robot


@onready var groundIntake: Arm = $CargoGroundIntakeArm
@onready var groundIntakeArea: IntakeArea = $SwerveBase/groundIntakeArea
@onready var passThroughArea: IntakeArea = $SwerveBase/passthroughArea
@onready var passthorughDetector: IntakeArea = $SwerveBase/PassthroughDetector
@onready var manipulatorCargoIntake: IntakeArea = $CascadeElevator/manipulator/ManipulatorCargoIntake
@onready var manipulatorCargoBlocker: CollisionShape3D = $CascadeElevator/manipulator/cargoBlocker
@onready var mainpCargoDetector: IntakeArea = $CascadeElevator/manipulator/ManipCargoDetector
@onready var elevator: CascadeElevator = $CascadeElevator
@onready var latervator: CascadeElevator = $hatchLatervator
@onready var climber: Arm = $climberHinge
@onready var hatchArmRight: Node3D = $hatchLatervator/latervator/HatchArm1
@onready var hatchArmLeft: Node3D = $hatchLatervator/latervator/HatchArm2

@onready var statemachine: StateMachine = StateMachine.new(WildstangStates.StoreState.new(self))


var hasHatch := false
var hatch: HatchPanel
var hasCargo := false
var cargo: Cargo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	add_child(statemachine)
	scoreboard.AftermatchStart.connect(scoreClimb)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if scoreboard.currentEnableState == scoreboard.enableStates.Enabled:
		processEnabled()
	
	if hasHatch:
		hatch.global_position = $hatchLatervator/latervator/HatchIntake.global_position
		hatch.rotation.x = 0
		hatch.rotation.y = 0


func removePieces():
	if not cargo == null:
		cargo.queue_free()
		hasCargo = false
	if not hatch == null:
		hatch.queue_free() 
		hasHatch = false


func processEnabled():
	if Input.is_action_just_pressed("cargoIntake"):
		statemachine.requestState(WildstangStates.CargoIntakeState.new(self))
	elif Input.is_action_just_released("cargoIntake"):
		statemachine.requestState(WildstangStates.StoreState.new(self))
	
	if Input.is_action_just_pressed("Eject"):
		if hasHatch:
			statemachine.requestState(WildstangStates.ScoreHatchPannel.new(self))
		else:
			manipulatorCargoBlocker.disabled = true
	elif Input.is_action_just_released("Eject"):
		manipulatorCargoBlocker.disabled = false
	
	if Input.is_action_just_pressed("ShipHeight"):
		if statemachine.currentState is WildstangStates.CargoShipState:
			statemachine.requestState(WildstangStates.StoreState.new(self))
		else:
			statemachine.requestState(WildstangStates.CargoShipState.new(self))
	
	if Input.is_action_just_pressed("RocketMid"):
		if statemachine.currentState is WildstangStates.RocketMiddleState:
			statemachine.requestState(WildstangStates.StoreState.new(self))
		else:
			statemachine.requestState(WildstangStates.RocketMiddleState.new(self))
	
	if Input.is_action_just_pressed("RocketHigh"):
		if statemachine.currentState is WildstangStates.RocketHighState:
			statemachine.requestState(WildstangStates.StoreState.new(self))
		else:
			statemachine.requestState(WildstangStates.RocketHighState.new(self))
	
	if Input.is_action_just_pressed("intakeHatch"):
		statemachine.requestState(WildstangStates.HatchIntakeState.new(self))
	elif Input.is_action_just_released("intakeHatch"):
		statemachine.requestState(WildstangStates.StoreState.new(self))
	
	if Input.is_action_just_pressed("RocketLow"):
		statemachine.requestState(WildstangStates.StoreState.new(self))
	
	if Input.is_action_just_pressed("climb"):
		if statemachine.currentState is WildstangStates.StoreState:
			statemachine.requestState(WildstangStates.ClimbState.new(self))
			print("climb")
		else:
			statemachine.requestState(WildstangStates.StoreState.new(self))
	
	if Input.is_action_just_pressed("CargoDrop"):
		var colorString := "Blue" if isBlue else "Red"
		var sideString := "+" if drivetrain.global_position.x >= 0.0 else "-"
		var hp: DeepSpaceHP = get_tree().root.get_node("GameWorld/2019-Field/"+colorString+"DriverStationWall/HP" + sideString)
		hp.dropCargo()


func _on_hatch_intake_area_entered(area: Area3D) -> void:
	if statemachine.currentState is WildstangStates.HatchIntakeState and area.get_parent() is HatchPanel:
		hatch = area.get_parent()
		hasHatch = true
		hatch.reparent($hatchLatervator/latervator)
		hatch.freeze = true
		hatch.global_position = $hatchLatervator/latervator/HatchIntake.global_position
		hatch.rotation.x = 0
		hatch.collision_layer = 0
		hatch.collision_mask = 0
		statemachine.requestState(WildstangStates.StoreState.new(self))


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
	if not cargo == null:
		cargo.queue_free()
		hasCargo = false
	if not hatch == null:
		hatch.queue_free() 
		hasHatch = false
	
	#add correct preload
	if startingGP == "Cargo":
		cargo = preload("res://src/fields/2019-DeepSpace/gamePieces/cargo.tscn").instantiate()
		add_child(cargo)
		cargo.position = Vector3(0.0, 0.71, 0.177)
		cargo.reparent(fieldNode)
	else:
		hatch = preload("res://src/fields/2019-DeepSpace/gamePieces/HatchPanel.tscn").instantiate()
		hasHatch = true
		$hatchLatervator/latervator.add_child(hatch)
		hatch.freeze = true
		hatch.global_position = $hatchLatervator/latervator/HatchIntake.global_position
		hatch.rotation.x = 0
		hatch.collision_layer = 0
		hatch.collision_mask = 0
	
	startingIndex = location
	preloadGP = startingGP
	statemachine.requestState(WildstangStates.StoreState.new(self))


func _on_manip_cargo_detector_body_entered(body: Node3D) -> void:
	if body is Cargo:
		hasCargo = true
		passThroughArea.enabled = false


func _on_manip_cargo_detector_body_exited(body: Node3D) -> void:
	if body is Cargo:
		hasCargo = false
		if hasHatch == false:
			passThroughArea.enabled = true


func _on_hatch_intake_area_exited(area: Area3D) -> void:
	if area.name == "inHabZone" and hasHatch:
		$hatchLatervator/latervator/FakeHatch.disabled = false
		#print("ran")
