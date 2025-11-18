extends Control

@onready var inv: Inv = preload("res://resources/player_inventory.tres")
@onready var slots: Array = $NinePatchRect2/GridContainer.get_children()

var is_open = false

func _ready() -> void:
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if not is_open and not WordlManager.history_is_open:
			open()
		else:
			close()

func open():
	visible = true
	is_open = true
	WordlManager.inv_is_open = true


func close():
	visible = false
	is_open = false
	WordlManager.inv_is_open = false

func add_item(item: Item):
	
