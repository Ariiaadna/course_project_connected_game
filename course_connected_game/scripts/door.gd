extends Node2D

@export var stat : Id_based_interactable

@onready var anim = $AnimatedSprite2D

var texture : SpriteFrames
var id : int

func _ready() -> void:
	texture = stat.texture
	id = stat.id
	anim.sprite_frames = texture
