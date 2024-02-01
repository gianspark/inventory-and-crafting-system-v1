extends Area2D

@export var item_data : ItemData

func _ready():
	$Sprite2D.texture = item_data.icon

func _on_body_entered(body):
	if(body is Player):
		if(body.inventory.add_item(item_data)):
			queue_free()
