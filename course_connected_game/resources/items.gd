extends Resource
class_name Item

@export var name: String = ""
@export var texture: Texture2D
@export var id: int

func _to_string() -> String:
	return name
