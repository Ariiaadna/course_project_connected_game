extends Area2D

@export var next_lvl : PackedScene

@onready var text = $Label

func _ready() -> void:
	text.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if !WordlManager.ai_door_is_close and !WordlManager.ai_cage_is_close:
			get_tree().change_scene_to_packed(next_lvl)
		else:
			text.visible = true


func _on_body_exited(body: Node2D) -> void:
	text.visible = false
