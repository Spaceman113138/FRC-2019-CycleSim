class_name StateMachine extends Node


var currentState:
	set(val):
		currentState = val
		currentState.initFunc()


func _physics_process(delta: float) -> void:
	#print(delta)
	currentState.executeFunc(delta)


func _init(startingState) -> void:
	currentState = startingState


func requestState(newState):
	if newState.requirements() == true:
		currentState.endFunc()
		currentState = newState
