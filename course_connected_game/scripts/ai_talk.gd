extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogManager.ai_position = self.global_position
