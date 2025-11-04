extends StaticBody2D

@onready var animation = $AnimatedSprite2D


func activate():
	animation.play("Opening")
	collision_layer = 128

func deactivate():
	animation.play("Closed")
	collision_layer = 5
