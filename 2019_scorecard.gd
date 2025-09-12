class_name DeepSpaceScorecard extends Control

enum enableStates {Disabled, Enabled}
enum gameStates {NotStarted, Sandstorm, Teleop, Endgame, AfterMatch}

var currentEnableState := enableStates.Disabled:
	set(val):
		if currentEnableState != val:
			currentEnableState = val
			if val == enableStates.Disabled:
				Disable.emit()
			else:
				Enable.emit()

var currentGameState := gameStates.NotStarted:
	set(val):
		if currentGameState != val:
			currentGameState = val
			match currentGameState:
				gameStates.Sandstorm:
					currentEnableState = enableStates.Enabled
					SandstormStart.emit()
				gameStates.Teleop:
					TeleopStart.emit()
				gameStates.Endgame:
					EndgameStart.emit()
				gameStates.AfterMatch:
					currentEnableState = enableStates.Disabled
					AftermatchStart.emit()
					timer.start()

signal Disable
signal Enable
signal SandstormStart
signal TeleopStart
signal EndgameStart
signal AftermatchStart

var blueHatchPlacements: Dictionary = {
	"Left" : 0,
	"Right" : 0,
	"Middle" : 0
}
var blueCargoPlacements: Dictionary = {
	"Left" : 0,
	"Right" : 0,
	"Middle" : 0
}

var redHatchPlacements: Dictionary = {
	"Left" : 0,
	"Right" : 0,
	"Middle" : 0
}
var redCargoPlacements: Dictionary = {
	"Left" : 0,
	"Right" : 0,
	"Middle" : 0
}

const autoTime: float = 15.0
const teleopTime: float = 135.0
const endgameTime: float = 20.0
const totalTime: float = autoTime + teleopTime
var currentTime: float = 0.0
@onready var timer: Timer = $Timer

@onready var timeBar: TextureProgressBar = $TextureRect/TimeElapsedBar
@onready var timeLabel: Label = $TextureRect/timeLabel

@onready var redScoreLabel: Label = $TextureRect/redScore
var redScore: int = 0.0:
	set(val):
		redScore = val
		redScoreLabel.text = str(redScore)

@onready var blueScoreLabel: Label = $TextureRect/blueScore
var blueScore: int = 0.0:
	set(val):
		blueScore = val
		blueScoreLabel.text = str(blueScore)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeBar.max_value = totalTime
	currentEnableState = enableStates.Disabled
	currentGameState = gameStates.NotStarted
	
	timer.timeout.connect(func(): currentEnableState = enableStates.Enabled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentTime = min(currentTime + delta, totalTime)
	timeLabel.text = str(ceili(totalTime - currentTime))
	if currentTime == totalTime: #GameEnd
		timeBar.tint_progress = Color.RED
		currentGameState = gameStates.AfterMatch
		
	elif ceilf(currentTime) <= autoTime: #Sandstorm
		currentGameState = gameStates.Sandstorm
		timeLabel.text = str(ceili(autoTime - currentTime))
	elif ceil(currentTime) > totalTime - endgameTime: #Endgame
		currentGameState = gameStates.Endgame
		timeBar.tint_progress = Color("f4f41bff")
	else: #Teleop
		currentGameState = gameStates.Teleop
	timeBar.value = ceili(currentTime)


func addHatchPannel(points: int, color: String, location: String):
	if color == "Blue":
		blueHatchPlacements[location] += 1
		blueScore += points
		get_node("TextureRect/Blue/hatch" + location).text = str(blueHatchPlacements[location])
	else:
		redHatchPlacements[location] += 1
		redScore += points
		get_node("TextureRect/Red/hatch" + location).text = str(redHatchPlacements[location])

func removeHatchPannel(points: int, color: String, location: String):
	if color == "TextureRect/Blue":
		blueHatchPlacements[location] -= 1
		blueScore -= points
		get_node("TextureRect/Blue/hatch" + location).text = str(blueHatchPlacements[location])
	else:
		redHatchPlacements[location] -= 1
		redScore -= points
		get_node("TextureRect/Red/hatch" + location).text = str(redHatchPlacements[location])

func addCargo(points: int, color: String, location: String):
	if color == "Blue":
		blueCargoPlacements[location] += 1
		blueScore += points
		get_node("TextureRect/Blue/cargo" + location).text = str(blueCargoPlacements[location])
	else:
		redCargoPlacements[location] += 1
		redScore += points
		get_node("TextureRect/Red/cargo" + location).text = str(redCargoPlacements[location])

func removeCargo(points: int, color: String, location: String):
	if color == "Blue":
		blueCargoPlacements[location] -= 1
		blueScore -= points
		get_node("TextureRect/Blue/cargo" + location).text = str(blueCargoPlacements[location])
	else:
		redCargoPlacements[location] -= 1
		redScore -= points
		get_node("TextureRect/Red/cargo" + location).text = str(redCargoPlacements[location])

func addSandstorm(points: int, color: String):
	if color == "Blue":
		blueScore += points
	else:
		redScore += points


func scoreClimb(level: int, color: String):
	if color == "Blue":
		match level:
			1:
				blueScore += 3
			2:
				blueScore += 6
			3:
				blueScore += 12
	else:
		match level:
			1: 
				redScore += 3
			2:
				redScore += 6
			3:
				redScore += 12
