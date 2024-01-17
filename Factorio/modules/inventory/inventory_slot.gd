class_name InventorySlot extends PanelContainer

signal pressed

@onready var texture_rect = %TextureRect
@onready var button = %Button
@onready var label_count = %LabelCount
@onready var label_name = %LabelName


var _inventory_item:InventoryItem

func _ready():
	_set_name("")
	_set_count(0)
	button.pressed.connect(emit_signal.bind("pressed"))
	
## Interface
func is_empty():
	return not _inventory_item

func put_inventory_item(value:InventoryItem):
	if _inventory_item:
		return false
	_inventory_item = value
	_set_texture(_inventory_item.texture)
	_set_count(_inventory_item.count)
	_set_name(_inventory_item.item.name)
	return true

func take_inventory_item():
	if not _inventory_item :
		return 
	var inventory_item = _inventory_item
	_inventory_item = null
	_set_texture(null)
	_set_count(0)
	_set_name("")
	return inventory_item

## Utils
func _set_texture(value:Texture2D):
	texture_rect.texture = value

func _set_count(value:int):
	if value <= 0:
		label_count.hide()
	else:
		label_count.show()
	label_count.text = str(value)

func _set_name(value:String):
	if value == "":
		label_name.hide()
	else:
		label_name.show()
	label_name.text = value
