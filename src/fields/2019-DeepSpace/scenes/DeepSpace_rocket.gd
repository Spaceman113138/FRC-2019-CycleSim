extends Node3D

@onready var frontDecal: Decal = $RocketBody/front
@onready var leftDecal: Decal = $RocketBody/left
@onready var rightDecal: Decal = $RocketBody/right
@onready var rightSprite: Sprite3D = $RocketWing2/rightSprite
@onready var leftSprite: Sprite3D = $RocketWing/leftSprite

var blueFront := preload("res://src/fields/2019-DeepSpace/resources/ge-19208-blue.png")
var blueLeft := preload("res://src/fields/2019-DeepSpace/resources/ge-19207-blue.png")
var blueRight := preload("res://src/fields/2019-DeepSpace/resources/ge-19209-blue.png")
var blueWingLeft := preload("res://src/fields/2019-DeepSpace/resources/ge-19116-blue.png")
var blueWingRight := preload("res://src/fields/2019-DeepSpace/resources/ge-19117-blue.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sign(global_position.z) == -1:
		frontDecal.texture_albedo = blueFront
		leftDecal.texture_albedo = blueLeft
		rightDecal.texture_albedo = blueRight
		rightSprite.texture = blueWingRight
		leftSprite.texture = blueWingLeft

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
