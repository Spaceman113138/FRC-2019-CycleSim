class_name State extends Node


var stateName: String


func _init(Name: String) -> void:
	stateName = Name


func initFunc() -> void:
	pass


func executeFunc(delta: float) -> void:
	pass


func endFunc() -> void:
	pass


func requirements() -> bool:
	return true
