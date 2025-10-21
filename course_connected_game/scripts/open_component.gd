extends Node2D

@onready var label = $Label

@export var animation : AnimatedSprite2D

var is_open = false

func _ready() -> void:
	label.visible = false


func open():
	animation.play("open")
	is_open = true
	label.visible = false
