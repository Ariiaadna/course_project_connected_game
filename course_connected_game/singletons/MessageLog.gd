extends Node

# хранит все сообщения в порядке добавления
var messages : Array = []

# максимальное количество сообщений в памяти (опционально)
@export var max_messages : int = 1000

signal message_added(msg: Dictionary)

func _ready():
	# если нужно — можно загрузить сохранённые сообщения
	pass

# добавляет сообщение в лог
func add_message(text: String, who: int) -> void:
	var msg = {
		"text": text,
		"who": who
	}
	messages.append(msg)
	# лимитируем память
	if messages.size() > max_messages:
		messages.remove_at(0) # удаляем самое старое
	emit_signal("message_added", msg)
	
# вернуть копию массива (не напрямую ссылку)
func get_messages() -> Array:
	return messages.duplicate(true)

# получить N последних сообщений
func get_last(n: int) -> Array:
	var start = max(0, messages.size() - n)
	return messages.slice(start, messages.size())
