extends Control

@onready var play_button: Button = $CenterContainer/VBoxContainer/Button
@onready var exit_button: Button = $CenterContainer/VBoxContainer/Button2

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_play_pressed():
	# Переход на игровую сцену
	get_tree().change_scene_to_file("res://scenese/1_lvl.tscn")

func _on_exit_pressed():
	get_tree().quit()
