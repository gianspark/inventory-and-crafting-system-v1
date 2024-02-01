extends Control

const SLOT_UI = preload("res://slot_ui.tscn")

var opened : bool = false

func _on_exit_button_button_down():
	var nodes = $PanelContainer/VBoxContainer/slots.get_children()
	for i in nodes:
		i.queue_free()
	hide()

func show_inventory(inv):
	for slot in inv.item_slots:
		var new_visual_slot = SLOT_UI.instantiate()
		new_visual_slot.set_parameters(slot.item.icon,slot.quantity)
		$PanelContainer/VBoxContainer/slots.add_child(new_visual_slot)
	show()

func _on_player_open_inventory(inv):
	if(opened):
		opened = false
		_on_exit_button_button_down()
	else:
		opened = true
		show_inventory(inv)
