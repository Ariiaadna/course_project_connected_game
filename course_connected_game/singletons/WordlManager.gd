extends Node

var player_can_walk = true
var history_can_open = true
var ai_can_otvet = true
var player_is_holding = false
var holding_object = null
var history_is_open = false

var inv_is_open = false

func _process(delta: float) -> void:
	if inv_is_open:
		player_can_walk = false
		history_can_open = false
	else:
		player_can_walk = true
		history_can_open = true
	
	if history_is_open:
		player_can_walk = false
	else:
		player_can_walk = true
