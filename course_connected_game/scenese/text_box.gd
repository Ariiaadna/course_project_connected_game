extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06 
var pun_time = 0.2

signal finished_displaying()

func display_text(text_to_display: String) -> void:
	#text = text_to_display
	#label.text = text_to_display
	
	# Сбрасываем состояние при каждом новом выводе
	text = text_to_display
	letter_index = 0
	timer.stop()
	
	# Сначала ставим полный текст (нужно для пересчёта размера)
	label.text = text_to_display
	
	await resized # ожидание сигнала об изменении размера тектового поля
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode= TextServer.AUTOWRAP_WORD
		await resized #опять дожидаемся изменения текста по горизонтали
		await resized #изменение по вертикали
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2 #центрируем его по горизонтале
	global_position.y -= size.y + 24 #чтобы он был немного выше говорящего 
	
	
	label.text = ""
	_display_letter()
				
func _display_letter():
		# Защита от выхода за границы (на случай, если text пуст)
		if letter_index < 0 or letter_index >= text.length():
			finished_displaying.emit()
			return
			
		label.text += text[letter_index]
		
		letter_index += 1
		if letter_index >= text.length() :
			finished_displaying.emit() #посылаем сигнал что всё 
			return
			
		#если ещё остались символы
		match text[letter_index]:
			"!", ".", ",", "?":
				timer.start(pun_time)
			" ":
				timer.start(space_time)
			_:
				timer.start(letter_time)			
	

func _on_timer_timeout() -> void:
	_display_letter()
