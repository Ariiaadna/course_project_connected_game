# MessageWindow.gd
extends Panel

#@onready var _scroll: ScrollContainer =$ScrollContainer
#@onready var _vbox: VBoxContainer = $ScrollContainer/MessagesVBox
# объявляем заранее, чтобы были доступны в любом месте кода
var _scroll: ScrollContainer
var _vbox: VBoxContainer
var _message_log: Node = null

# При старте прячем окно
func _ready():
	await get_tree().process_frame  # 🔥 ждём один кадр, чтобы все ноды стали доступны
	_scroll = $ScrollContainer
	_vbox = $ScrollContainer/MessagesVBox
	visible = false
	# Подключаем сигнал, чтобы новые сообщения добавлялись в окно
	MessageLog.message_added.connect(_on_message_added)
	# Загружаем уже имеющиеся сообщения
	_refresh_messages()

func _process(_delta):
	if Input.is_action_just_pressed("toggle_messages") \
	and WordlManager.history_can_open and not WordlManager.inv_is_open:
		WordlManager.history_is_open = not WordlManager.history_is_open
		visible = not visible
		if visible:
			# обновляем при открытии
			_refresh_messages()
			await get_tree().process_frame
			_scroll_to_bottom()

# Добавить одно сообщение
func _on_message_added(msg: Dictionary):
	if not visible:
		var lbl := _create_message_label(msg)
		_vbox.add_child(lbl)
		await get_tree().process_frame
	if visible:
		_scroll_to_bottom()
	#var label = _create_message_label(msg)
	#_vbox.add_child(label)
	#await get_tree().process_frame
	#_scroll_to_bottom()

# Обновить всё окно
func _refresh_messages() -> void:
	if _vbox == null or _message_log == null:
		return
		
	# удаляем старые сообщения вручную
	for child in _vbox.get_children():
		child.queue_free()

	# добавляем заново все сообщения из лога
	for msg in _message_log.get_messages():
		_vbox.add_child(_create_message_label(msg))
		
# Создаёт одну строку (Label)
func _create_message_label(msg: Dictionary) -> Label:
	var who: int = int(msg.get("who", 0))
	var who_text: String = "Player" if who == 1 else "AI"
	var lbl: Label = Label.new()
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.custom_minimum_size.x = 950 # <-- минимальная ширина (можно настроить)
	lbl.text = "%s: %s" % [who_text, String(msg.get("text", ""))]
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.clip_text = false
	return lbl


func _scroll_to_bottom() -> void:
	if _scroll == null:
		return
	await get_tree().process_frame  # ждём, пока layout обновится
	_scroll.scroll_vertical = 9999999
