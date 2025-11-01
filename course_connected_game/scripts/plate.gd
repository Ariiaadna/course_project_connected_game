extends Node2D

@export var connection : Node2D

@onready var animation = $AnimatedSprite2D
@onready var area = $Area2D

func _ready() -> void:
	animation.play("closed")

func _on_area_2d_body_entered(body: Node2D) -> void:
	connection.activate()
	animation.play("open")

func _on_area_2d_body_exited(body: Node2D) -> void:
	connection.deactivate()
	animation.play("closed")
