class_name StateMachine extends Node


var currentState:
	set(val):
		currentState = val
		currentState.initFunc()


func _init(startingState) -> void:
	currentState = startingState


func runExecuteFunc():
	currentState.executeFunc()


func requestState(newState):
	if newState.requirements() == true:
		currentState.endFunc()
		currentState = newState
