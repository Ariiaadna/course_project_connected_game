extends Control

var p_text: String = ""
var chat_open

@export var input_field: TextEdit 
@export var panel: Panel
@export var talk_position: Marker2D


func _ready() -> void:
	panel.visible = false 
	chat_open = false

func _process(delta: float) -> void:
	if chat_open:
		if Input.is_action_just_pressed("Chat"):
			WordlManager.player_can_walk = true
			chat_open = false
			panel.visible = false
			input_field.clear()
		elif Input.is_action_just_pressed("Accept"):
		#if Input.is_action_just_pressed("Accept"):
			WordlManager.player_can_walk = true
			p_text = input_field.text
			p_text = input_field.text.strip_edges()
			if p_text != "":
				print("Введено: ", p_text)
				DialogManager.player_position = talk_position.global_position
				DialogManager.is_player_talk = true
				DialogManager.clean_message(p_text)
			else:
				print("Пусто")
			chat_open = false
			panel.visible = false
			input_field.clear()
	else:
		if Input.is_action_just_pressed("Chat"):
			WordlManager.player_can_walk = false
			chat_open = true
			panel.visible = true
			input_field.grab_focus()
