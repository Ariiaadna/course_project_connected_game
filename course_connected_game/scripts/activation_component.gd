extends Node2D

@onready var label = $Label

@export var main : Node2D
@export var is_swtichable = false
@export var is_interactable = true

var connection
var is_active = false

func _ready() -> void:
	connection = main.connection
	label.visible = false

func activate():
	if is_swtichable:
		if is_active:
			connection.activate()
			is_active = true
			main.closed()
		else:
			connection.deactivate()
			is_active = false
			main.open()
	elif not is_swtichable and not is_active:
		connection.activate()
		is_active = true
		label.visible = false
		main.closed()
