extends NobodyWhoChat

@onready var label = $"../text_box/MarginContainer/Label"
@onready var main = $".."

var holding : Item
var env_contain : String
var has_button = false
var has_note = false
var has_chest = false
var has_box = false
var has_barricade = false
var has_cage = false
var has_door = false
var player_inventory

func _ready():
	await scan_env()
	player_inventory = main.player_node.get_node("Inventory_Ui")
	var prompt = main.ai_lvl_prompt + "Ты подруга игрока, вы заперты в доме.
Тебя зовут Алиса. 
Мило отвечай на запросы. Пиши кратко. Не используй многоточий.
Вызывай функции, только если имеешь четкие указания от игрока"
	# configure the node (feel free to do this in the UI)
	self.system_prompt = prompt
	self.model_node = get_node("../NobodyWhoModel")
	# connect signals to signal handlers
	self.response_updated.connect(_on_response_updated)
	self.response_finished.connect(_on_response_finished)

	# Start the worker, this is not required, but recommended to do in
	# the beginning of the program to make sure it is ready
	# when the user prompts the chat the first time. This will be called
	# under the hood when you use say() as well.
	self.start_worker()

	#self.say("Как ты себя чувствуешь?")
	
	#TOOL CALING
	add_tool(get_stats, "Используй эту функцию, только когда кто-то спросит тебя о твоем возрасте или возрасте игрока.")
	add_tool(press_button, "Используй эту функцию, только когда кто-то попросит тебя нажать на кнопку.")
	add_tool(inspection, "Используй эту функцию, только когда кто-то попросит тебя осмотреть комнату вокруг себя.")
	add_tool(read, "Используй эту функцию, только когда кто-то попросит тебя прочитать записку.")
	add_tool(move_box, "Используй эту функцию, только когда кто-то попросит тебя подвинуть или передвинуть ящик. Сообщи игроку, если за ящиком что-то будет. Не принимай дальнейших решений без него")
	add_tool(open_chest, "Используй эту функцию, только когда кто-то попросит тебя заглянуть в сундук. Сообщи игроку об содрежимом сундука.")
	add_tool(check_inventory, "Используй эту функцию, только когда кто-то попросит тебя рассказать что у тебя в руках.")
	add_tool(give_item, "Используй эту функцию, только когда кто-то попросит тебя передать предмет из твоих рук.")
	add_tool(open_door, "Используй эту функцию, только когда кто-то попросит тебя открыть дверь в твоей комнате твоим ключом, если ты его держишь.")
	add_tool(check_exit, "Используй эту функцию, только когда кто-то спросит тебя можешь ли ты сейчас выйти из комнаты.")
	reset_context()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start_dialog") and WordlManager.ai_can_otvet:
		self.say(DialogManager.get_player_say())
	
	if Input.is_action_just_pressed("TEST"):
		print(holding)

func _on_response_updated(token):
	# this will print every time a new token is generated
	DialogManager.is_player_talk = false
	DialogManager.show_thinking()
	print(token)


func _on_response_finished(response):
	# this will print when the entire response is finishe
	#label.set_text(clean_message(response))
	DialogManager.stop_thinking()
	DialogManager.is_player_talk = false
	DialogManager.clean_message(response)
	#DialogManager.process_ai_json(response)
	MessageLog.add_message(DialogManager.delete_think(response), 2)
	player_inventory.update_slots()

func scan_env():
	for object in main.enviorment.enviorment:
		if object.name == "Кнопка":
			has_button = true
			if !main.button_hidden:
				env_contain += object.name + ", "
		elif object.name == "Записка":
			has_note = true
			env_contain += object.name + ", "
		elif  object.name == "Сундук":
			has_chest = true
			env_contain += object.name + ", "
		elif  object.name == "Ящик":
			has_box = true
			env_contain += object.name + ", "
		elif object.name == "Баррикада":
			has_barricade = true
			env_contain += object.name + ", "
		elif object.name == "Дверь":
			has_door = true
			env_contain += object.name + ", "
		elif object.name == "Решетка":
			has_door = true
			env_contain += object.name + ", "
		elif object.name == "Телепорт для предметов":
			has_door = true
			env_contain += object.name + ", "

#TOOL CALLING и всё с ним связанное
var ai_age = 21
var player_age = 34

func get_stats() -> String:
	return JSON.stringify({
		"Your age": ai_age,
		"Player age": player_age
	})

#Нажатие на кнопку
func press_button():
	if has_button and not main.button_hidden:
		main.activation()
		return "Что-то произошло"
	else:
		return "Кнопки тут нет"

#Осмотр комнаты
func inspection():
	return env_contain

#Чтение записки
func read():
	if has_note:
		return main.note.text
	else:
		return "Записки тут нет"

#Передвижение ящика
func move_box():
	if has_box:
		if main.how_hidden == main.hidden_property.Box:
			main.button_hidden = false
			env_contain += "Кнопка, "
			return "За ящиком кнопка"
		else:
			return "За ящиком пусто"
	else:
		return "Тут нет ящика"

#Открытие сундука
func open_chest():
	if has_chest:
		if main.chest_container:
			holding = main.chest_container
			main.chest_container = null
			print(holding.id)
			return holding
		else:
			return "В сундуке пусто"
	else:
		return "Тут нет сундука"

#Проверка инвентроря/того что у в руках у ии
func check_inventory():
	if holding:
		print(holding)
		return holding
	else:
		return "У меня ничего нет"

#Передача предмета от ии к игроку
func give_item():
	if main.can_change and holding:
		player_inventory.add_item(holding)
		holding = null
		return "Держи"
	else:
		return "Я не могу тебе ничего передать"

func open_door():
	if has_door:
		if holding and main.door_id and holding.id == main.door_id:
			WordlManager.ai_door_is_close = false
			return "Дверь открылась, теперь я могу пройти!"
		elif holding and main.door_id and holding.id != main.door_id:
			return "Ключ не подошел"
		elif !holding:
			"Мне нечем открыть дверь"
	else:
		return "Тут нет двери"

func check_exit():
	if WordlManager.ai_door_is_close:
		return "Передо мной закрытая дверь. Сообщи об этом игроку"
	elif WordlManager.ai_cage_is_close:
		return "Передо мной закрытая решетка. Сообщи об этом игроку"
	else:
		return "Путь свободен. Сообщи об этом игроку"
