extends Node2D

@export var enviorment : Env
@export var button_hidden : bool
@export var how_hidden : hidden_property
@export var note : Note
@export var chest_container : Item
@export var can_change : bool
@export var player_node : CharacterBody2D
@export var ai_lvl_prompt : String
@export var door_id : int
@export var has_cage : bool

enum hidden_property { Not, Barricade, Box }

var activation_component: Node = null

func _ready() -> void:
	activation_component = find_activation_component()
	print(find_activation_component())
	
	if !door_id == 0:
		WordlManager.ai_door_is_close = true
	else:
		WordlManager.ai_door_is_close = false
	
	if has_cage:
		WordlManager.ai_cage_is_close = true
	else:
		WordlManager.ai_cage_is_close = false
	
	print(WordlManager.ai_cage_is_close)
	print(WordlManager.ai_door_is_close)

func find_activation_component() -> Node:
	for child in get_children():
		if child.owner == owner and child.has_node("ActivationComponent"):
			return child.get_node("ActivationComponent")
	return null

func activation():
	if activation_component:
		activation_component.activate()
