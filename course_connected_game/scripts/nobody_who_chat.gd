extends NobodyWhoChat

@onready var label = $"../text_box/MarginContainer/Label"
@onready var main = $".."

func _ready():
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
	add_tool(press_button, "Используй эту функцию, когда игрок попросит тебя нажать на кнопку.")
	reset_context()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start_dialog") and WordlManager.ai_can_otvet:
		self.say(DialogManager.get_player_say())
		
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


#TOOL CALLING и всё с ним связанное
var ai_age = 21
var player_age = 34

func get_stats() -> String:
	return JSON.stringify({
		"Your age": ai_age,
		"Player age": player_age
	})

func press_button():
	main.activation()
