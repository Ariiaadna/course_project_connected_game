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
var player_inventory

func _ready():
	await scan_env()
	player_inventory = main.player_node.get_node("Inventory_Ui")
	# configure the node (feel free to do this in the UI)
	self.system_prompt = "Ты помощница игрока, вы заперты в доме.
Тебя зовут Алиса. 
Мило отвечай на запросы. Пиши кратко. Не используй многоточий."
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
	add_tool(get_stats, "Используй эту функцию, когда кто-то спросит тебя о твоем возрасте или возрасте игрока.")
	add_tool(press_button, "Используй эту функцию, когда кто-то попросит тебя нажать на кнопку.")
	add_tool(inspection, "Используй эту функцию, когда кто-то попросит тебя осмотреть помещение вокруг себя.")
	add_tool(read, "Используй эту функцию, когда кто-то попросит тебя прочитать записку.")
	add_tool(move_box, "Используй эту функцию, когда кто-то попросит тебя подвинуть или передвинуть ящик. Сообщи игроку, если за ящиком что-то будет. Не принимай дальнейших решений без него")
	add_tool(open_chest, "Используй эту функцию, когда кто-то попросит тебя заглянуть в сундук. Сообщи игроку об содрежимом сундука.")
	add_tool(check_inventory, "Используй эту функцию, когда кто-то попросит тебя рассказать что у тебя в руках.")
	add_tool(give_item, "Используй эту функцию, когда кто-то попросит тебя передать предмет из твоих рук.")
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
		elif object.name == "Решетка":
			has_cage = true
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
