extends Node2D

@export var left_hand: Marker2D
@export var right_hand: Marker2D
@export var main: CharacterBody2D

var current_object
var current_side
var is_holding = false

func _ready() -> void:
	current_side = right_hand

func _process(delta: float) -> void:
	WordlManager.holding_object = current_object
	if is_holding:
		hold()
	if not is_holding:
		current_object = null

func hold():
	current_object.global_position = current_side.global_position
	#current_object.collision_layer = 4 

func pick(target):
	WordlManager.player_is_holding = true
	is_holding = true
	current_object = target

func drop():
	is_holding = false
	WordlManager.player_is_holding = false
