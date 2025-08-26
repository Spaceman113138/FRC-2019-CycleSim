class_name DeepSpaceScorecard extends Control


@onready var scoreLabel: Label = $HBoxContainer/score
@onready var hatchesLabel: Label = $HBoxContainer/hatches
@onready var cargoLabel: Label = $HBoxContainer/cargo

var hatchesScored: int = 0:
	set(val):
		hatchesScored = val
		hatchesLabel.text = "Hatches Scored: " + str(hatchesScored)
var cargoScored: float = 0.0:
	set(val):
		cargoScored = val
		cargoLabel.text = "Cargo Scored: " + str(cargoScored)
var score: float = 0.0:
	set(val):
		score = val
		scoreLabel.text = "Total Score: " + str(score)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func addHatchPannel():
	hatchesScored += 1
	score += 2

func removeHatchPannel():
	hatchesScored -= 1
	score -= 2

func addCargo(points: int):
	cargoScored += 1
	score += points

func removeCargo(points: int):
	cargoScored -= 1
	score -= points
