class_name Display extends Control

@onready var texture_rect = %TextureRect
@onready var label_count = %LabelCount

var _item:InventoryItem

func _ready():
	size = Vector2.ZERO
	Globals.display = self

func _process(delta):
	if _item:
		global_position = get_global_mouse_position()

func has_item():
	return _item != null

func get_item():
	return _item

func set_item(value:InventoryItem):
	_item = value
	_update()

func clear_item():
	_item = null
	_update()

func _update():
	if _item:
		texture_rect.texture = _item.texture
		label_count.text = str(_item.count)
		show()
	else:
		texture_rect.texture = null
		label_count.text = str(0)
		hide()
