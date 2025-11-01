extends Node2D

@export var connection : Node2D

@onready var animation = $AnimatedSprite2D

func open():
	animation.play("disactive")

func closed():
	animation.play("active")
