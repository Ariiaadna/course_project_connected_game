extends Node2D

@onready var label = $Label

@export var animation : AnimatedSprite2D
@export var container : Node2D
@export var is_locked = false
@export var main : Node2D

var key_id
var standart_label_text = "Использовать: E"
var wrong_id_label_text = "Нет нужного ключа"

var is_open = false

func _ready() -> void:
	set_text(standart_label_text)
	label.visible = false

func set_id():
	key_id = main.id

func open():
	animation.play("open")
	is_open = true
	label.visible = false
	if is_locked:
		main.collision_layer = 128

func set_text(text):
	label.text = text
