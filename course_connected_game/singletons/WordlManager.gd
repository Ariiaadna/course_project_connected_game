extends Node

var player_can_walk = true
var history_can_open = true
var ai_can_otvet = true
var inv_can_open = true
var chat_can_open = true
var note_can_open = true

var player_is_holding = false
var holding_object = null

var history_is_open = false
var inv_is_open = false
var note_is_open = false
var chat_is_open = false

var ai_door_is_close = false
var ai_cage_is_close = false

func _process(delta: float) -> void:
	if inv_is_open or history_is_open or note_is_open or chat_is_open:
		player_can_walk = false
		chat_can_open = false
		inv_can_open = false
		note_can_open = false
	else:
		player_can_walk = true
		chat_can_open = true
		inv_can_open = true
		note_can_open = true
		

	
	#if history_is_open:
	#	player_can_walk = false
	#else:
	#	player_can_walk = true
