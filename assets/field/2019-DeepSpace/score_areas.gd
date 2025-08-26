class_name ScoreAreas extends Area3D


@export var pointValue = 3.0
var scorecard: DeepSpaceScorecard

var time: float = 0.0
var scored := false:
	set(val):
		if val != scored and val:
			scorecard.addCargo(pointValue)
		elif val != scored:
			scorecard.removeCargo(pointValue)
		scored = val


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scorecard = get_tree().root.get_node("Node3D/2019-Field/2019Scorecard")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var touchedCargo := false
	for collision in get_overlapping_bodies():
		if collision is Cargo:
			time += delta
			touchedCargo = true
			break
	
	if not touchedCargo:
		time = 0.0
	
	if time > 1.0:
		scored = true
	else: 
		scored = false
