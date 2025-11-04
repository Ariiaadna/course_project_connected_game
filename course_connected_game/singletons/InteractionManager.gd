extends Node


#!!! Sender тут на будущее, чтобы сразу легко определять куда отрпавялть информацию об предмете
func check_interaction(target, sender):
	if target.has_node("OpenComponent"):
		var open_component = target.get_node("OpenComponent")
		if not open_component.is_open:
			open_component.open()
	
	if target.has_node("ActivationComponent"):
		var activate_component = target.get_node("ActivationComponent")
		activate_component.activate()

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
