extends Node2D

@onready var exit_button: Button = $Label/Button2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)    # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
