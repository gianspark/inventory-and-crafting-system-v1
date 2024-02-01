extends Control

@export var list_of_recipes : Array[RecipeData] = []
@onready var item_list : ItemList = %ItemList
const SLOT_UI = preload("res://slot_ui.tscn")

@export var opened = false

var selected_index : int = 0

func _ready():
	for i in list_of_recipes:
		item_list.add_item(i.name)
	_on_item_list_item_selected(0)

func _on_item_list_item_selected(index):
	selected_index = index
	var pool = %needed.get_children()
	for i in pool:
		i.queue_free()
	pool = %result.get_children()
	for i in pool:
		i.queue_free()
	
	var get_recipe = list_of_recipes[index] as RecipeData
	var new_result_slot = SLOT_UI.instantiate()
	new_result_slot.set_parameters(get_recipe.result.icon,1)
	%result.add_child(new_result_slot)
	
	for i in get_recipe.items_required:
		var new_required = SLOT_UI.instantiate()
		new_required.set_parameters(i.item.icon,i.quantity)
		%needed.add_child(new_required)

func _on_player_open_crafting():
	if(opened):
		opened = false
		hide()
	else:
		opened = true
		show()

func _on_craft_button_down():
	if(can_craft()):
		var player = get_tree().get_nodes_in_group("player").pop_at(0)
		var inventory = player.inventory
		var recipe_to_craft : Array[SlotData] = list_of_recipes[selected_index].items_required
		for item_required in recipe_to_craft:
			for item_in_inventory in inventory.item_slots:
				if(item_required.item == item_in_inventory.item):
					item_in_inventory.quantity -= item_required.quantity
					break
		inventory.update_slots()
		inventory.add_item(list_of_recipes[selected_index].result)

func can_craft():
	var player = get_tree().get_nodes_in_group("player").pop_at(0)
	var inventory = player.inventory
	var recipe_to_craft : Array[SlotData] = list_of_recipes[selected_index].items_required.duplicate()
	for item_required in recipe_to_craft:
		for item_in_inventory in inventory.item_slots:
			if(item_required.item == item_in_inventory.item and item_in_inventory.quantity >= item_required.quantity):
				recipe_to_craft.erase(item_required)
				break
	if(recipe_to_craft.is_empty()):
		return true
	else:
		return false
