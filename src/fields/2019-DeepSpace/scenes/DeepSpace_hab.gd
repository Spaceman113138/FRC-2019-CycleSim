extends Node3D

@onready var rightMesh: MeshInstance3D = $rightCargoHolder
@onready var leftMesh: MeshInstance3D = $leftCargoHolder
@onready var habFloor: MeshInstance3D = $habFloor
@onready var hab: MeshInstance3D = $hab
@onready var hablineMesh: MeshInstance3D = $HabLine
@onready var habline2Mesh: MeshInstance3D = $HabLine2

var redMesh := preload("res://src/fields/2019-DeepSpace/resources/red.tres")
var darkerRedMesh := preload("res://src/fields/2019-DeepSpace/resources/darkerRed.tres")

var scoreboard: DeepSpaceScorecard
var autoPointsUsed: Array[Robot] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreboard = get_tree().root.get_node("GameWorld/2019-Field/2019Scorecard")
	
	if global_position.z > 0:
		for i in range(rightMesh.get_surface_override_material_count()):
			rightMesh.set_surface_override_material(i, redMesh)
		
		for i in range(leftMesh.get_surface_override_material_count()):
			leftMesh.set_surface_override_material(i, redMesh)
		
		for i in range(habFloor.get_surface_override_material_count()):
			if i == 1 or i == 3 or i == 4:
				habFloor.set_surface_override_material(i, darkerRedMesh)
			else:
				habFloor.set_surface_override_material(i, redMesh)
		
		for i in range(hab.get_surface_override_material_count()):
			if i == 1 or i == 9 or i == 7:
				hab.set_surface_override_material(i, redMesh)
		hablineMesh.set_surface_override_material(0, redMesh)
		habline2Mesh.set_surface_override_material(0, redMesh)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_in_hab_zone_body_exited(body: Node3D) -> void:
	if scoreboard.currentGameState == scoreboard.gameStates.Sandstorm and body is SwerveBase:
		var robotNode: Robot = body.get_parent() as Robot
		#print("here")
		if robotNode != null and not autoPointsUsed.has(robotNode):
			"there"
			autoPointsUsed.append(robotNode)
			scoreboard.addSandstorm(3 if robotNode.startingIndex < 3 else 6,
									"Blue" if robotNode.isBlue else "Red")
