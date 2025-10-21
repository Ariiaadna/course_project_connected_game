extends Node

@onready var text_box_scene = preload("res://scenese/text_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

var position
var ai_position : Vector2
var player_position: Vector2
var is_player_talk: bool

#func start_dialog(position: Vector2, lines: Array[String]):
func start_dialog(lines: Array[String]):
	if is_player_talk:
		position = player_position
	else:
		position = ai_position
	if is_dialog_active:
		return 
	dialog_lines = lines
	text_box_position = position
	_show_text_box()
	
	is_dialog_active = true

func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event):
	if (
		event.is_action_pressed("advance_dialog") &&
		is_dialog_active &&
		can_advance_line
	):
		text_box.queue_free()
		current_line_index += 1
		
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false 
			current_line_index = 0
			return
			
		_show_text_box()


func clean_message(msg: String) -> void:
	# 1. Убираем блок <think>...</think>
	while true:
		var start := msg.find("<think>")
		var end := msg.find("</think>")
		if start == -1 or end == -1:
			break
		msg = msg.substr(0, start) + msg.substr(end + 8) # 8 символов в "</think>"

	# 2. Убираем нечитаемые символы (оставляем буквы, цифры, пробелы и базовую пунктуацию)
	var allowed := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZабвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ0123456789 .,!?;:-()"
	var clean_text := ""
	for c in msg:
		if allowed.find(c) != -1:
			clean_text += c

	
	# 3. Разбиваем на предложения вручную
	var sentences: Array[String] = []
	var current := ""
	for c in clean_text:
		current += c
		if c == "." or c == "!" or c == "?":
			var sentence := current.strip_edges()
			if sentence != "":
				sentences.append(sentence)
			current = ""
	# если осталось что-то после цикла — добавляем
	if current.strip_edges() != "":
		sentences.append(current.strip_edges())
	
	start_dialog(sentences)
