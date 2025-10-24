extends Node

@onready var text_box_scene = preload("res://scenese/text_box.tscn")

var player_say: String = ""
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

# thinking state
var thinking: bool = false
var thinking_timer: Timer = null
var thinking_dots: int = 0
const THINK_BASE_TEXT := "думает"

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
	# Очистим старый, если есть
	if text_box and text_box.is_inside_tree():
		text_box.queue_free()
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event):
	# блокируем пропуск во время мысли
	if thinking:
		return

	
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
	
# =========================
# 💭 Показываем "думает..."
# =========================
func show_thinking():
	if thinking:
		return # уже думает
	
	# Пометим состояние — блокирует ввод
	thinking = true
	is_dialog_active = true
	can_advance_line = false
	thinking_dots = 0

	# Создаём text box, но НЕ через display_text (чтобы не запускать по-буквенную печать)
	text_box = text_box_scene.instantiate()
	get_tree().root.add_child(text_box)
	text_box.global_position = ai_position
	text_box.global_position.x -= text_box.size.x + 4
	text_box.global_position.y -= text_box.size.y + 24

	# Пишем начальный текст сразу (label доступен в инстансе text_box)
	# Если в text_box.label путь другой — поменяй на правильный
	if text_box.has_node("MarginContainer/Label"):
		text_box.get_node("MarginContainer/Label").text = THINK_BASE_TEXT
	else:
		# для безопасности — пытаемся через свойство
		if text_box.has_variable("label"):
			text_box.label.text = THINK_BASE_TEXT

	# Создаём таймер (один раз)
	if thinking_timer != null and thinking_timer.is_inside_tree():
		thinking_timer.queue_free()
	thinking_timer = Timer.new()
	thinking_timer.wait_time = 0.5
	thinking_timer.one_shot = false
	add_child(thinking_timer)
	thinking_timer.connect("timeout", Callable(self, "_on_thinking_timeout"))
	thinking_timer.start()

func _on_thinking_timeout():
	# увеличиваем точки 0..3 (0 = нет точек)
	thinking_dots = (thinking_dots + 1) % 4
	var dots_text := ".".repeat(thinking_dots)
	var full := THINK_BASE_TEXT + dots_text

	# Обновляем метку
	if text_box:
		if text_box.has_node("MarginContainer/Label"):
			text_box.get_node("MarginContainer/Label").text = full
		elif text_box.has_variable("label"):
			text_box.label.text = full

# Останавливаем "думает..." когда ответ готов
func stop_thinking():
	if not thinking:
		return

	thinking = false
	is_dialog_active = false
	can_advance_line = false

	if thinking_timer:
		thinking_timer.stop()
		thinking_timer.queue_free()
		thinking_timer = null

	if text_box and text_box.is_inside_tree():
		text_box.queue_free()
		text_box = null


func set_player_say(what_say: String) -> void: 
	player_say = what_say
	print ("what_say = ", what_say, " player_say = ", player_say)

func get_player_say() -> String: 
	print (" player_say = ", player_say)
	return player_say 
	
