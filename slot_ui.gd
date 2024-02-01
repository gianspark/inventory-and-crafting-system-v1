extends PanelContainer

var icon : AtlasTexture
var quantity : int = 0

func set_parameters(ic, quan):
	quantity = quan
	icon = ic

func _enter_tree():
	if(quantity == 1):
		$quantity.hide()
	else:
		$quantity.text = str(quantity)
	$MarginContainer/icon.texture = icon
