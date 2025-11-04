extends Node2D

@export var main: CharacterBody2D
@onready var area: Area2D = $Area

var target: Node2D = null

func _ready() -> void:
	area.body_entered.connect(_on_area_body_entered)
	area.body_exited.connect(_on_area_body_exited)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and target:
		var sender := main
		InteractionManager.check_interaction(target, sender)
	
	if Input.is_action_just_pressed("Pick") and target and not WordlManager.player_is_holding:
		var sender := main
		InteractionManager.check_pickup(target, sender)
	elif Input.is_action_just_pressed("Pick") and WordlManager.player_is_holding:
		var sender := main
		target = WordlManager.holding_object
		InteractionManager.check_pickup(target, sender)

func _on_area_body_entered(body: Node2D) -> void:
	target = body
	print(target)
	InteractionManager.interaction_visible(target)

func _on_area_body_exited(body: Node2D) -> void:
	if body == target:
		InteractionManager.interaction_invisible(target)
		target = null
