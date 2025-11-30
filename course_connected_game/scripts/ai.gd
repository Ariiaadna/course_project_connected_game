extends Node2D

var activation_component: Node = null

func _ready() -> void:
	activation_component = find_activation_component()
	print(find_activation_component())

func find_activation_component() -> Node:
	for child in get_children():
		if child.owner == owner and child.has_node("ActivationComponent"):
			return child.get_node("ActivationComponent")
	return null

func activation():
	if activation_component:
		activation_component.activate()
