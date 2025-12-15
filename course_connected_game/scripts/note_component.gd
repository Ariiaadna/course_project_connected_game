extends Node2D

@export var note : Note
var text
var is_open = false

func _ready() -> void:
	text = note.text
