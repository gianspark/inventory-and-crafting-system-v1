extends CharacterBody2D
class_name Player

const SPEED : int = 500

@export var limit_size : int = 0
var inventory : Inventory

signal open_inventory()
signal open_crafting()

class Inventory:
	var item_slots : Array[SlotData] = []
	var limit_size : int = 0
	
	func _init(i : int):
		limit_size = i
	
	func add_item(item : ItemData) -> bool:
		for slot in item_slots:
			if(slot.item == item and item.unique == false):
				slot.quantity += 1
				return true
		if(item_slots.size() == limit_size):
			return false
		var slot = SlotData.new()
		slot.item = item
		slot.quantity = 1
		item_slots.append(slot)
		return true
	
	func update_slots():
		for i in item_slots:
			if(i.quantity <= 0):
				item_slots.erase(i)

func _ready():
	inventory = Inventory.new(limit_size)

func _process(delta):
	var dir : Vector2 = Vector2.ZERO
	
	if(Input.is_action_pressed("l")):
		dir += Vector2(-1,0)
	if(Input.is_action_pressed("r")):
		dir += Vector2(1,0)
	if(Input.is_action_pressed("u")):
		dir += Vector2(0,-1)
	if(Input.is_action_pressed("d")):
		dir += Vector2(0,1)
	if(Input.is_action_just_pressed("inventory")):
		emit_signal("open_inventory",inventory)
	if(Input.is_action_just_pressed("crafting")):
		emit_signal("open_crafting")
	
	
	dir = dir.normalized()
	velocity = (SPEED * dir * delta) * 30
	move_and_slide()

func get_inventory():
	print("hola")
