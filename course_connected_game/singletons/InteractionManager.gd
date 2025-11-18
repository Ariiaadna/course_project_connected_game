extends Node


#!!! Sender тут на будущее, чтобы сразу легко определять куда отрпавялть информацию об предмете
func check_interaction(target, sender):
	if target.has_node("OpenComponent"):
		var open_component = target.get_node("OpenComponent")
		if not open_component.is_locked:
			unlocked_interaction(target, sender)
		else:
			var inventory = sender.get_node("Inventory_Ui")
			open_component.set_id()
			if inventory.has_item_id(open_component.key_id):
				unlocked_interaction(target, sender)
			else:
				open_component.set_text(open_component.wrong_id_label_text)
	
	if target.has_node("ActivationComponent"):
		var activate_component = target.get_node("ActivationComponent")
		activate_component.activate()

func unlocked_interaction(target, sender):
	var open_component = target.get_node("OpenComponent")
	if not open_component.is_open:
		open_component.open()
	if not open_component.container == null:
		var item = target.content
		var inventory = sender.get_node("Inventory_Ui")
		inventory.add_item(item)
		inventory.update_slots()
		target.content = null

func check_pickup(target, sender):
	if target.has_node("PickUpComponent"):
		var holding_component = sender.get_node("HoldingComponent")
		if not holding_component.is_holding:
			holding_component.pick(target)
		else:
			holding_component.drop()


func interaction_visible(target):
	if target.has_node("OpenComponent"):
		var open_component = target.get_node("OpenComponent")
		if not open_component.is_open:
			open_component.set_text(open_component.standart_label_text)
			open_component.label.visible = true
	
	if target.has_node("ActivationComponent"):
		var activate_component = target.get_node("ActivationComponent")
		if not activate_component.is_active:
			activate_component.label.visible = true

func interaction_invisible(target):
	if target.has_node("OpenComponent"):
		var open_component = target.get_node("OpenComponent")
		open_component.label.visible = false
	
	if target.has_node("ActivationComponent"):
		var activate_component = target.get_node("ActivationComponent")
		activate_component.label.visible = false
