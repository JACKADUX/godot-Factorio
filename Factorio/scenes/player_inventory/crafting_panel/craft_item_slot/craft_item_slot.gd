class_name CraftItemSlot extends Button

@onready var texture_rect = %TextureRect
@onready var label_count = %LabelCount

var item:BaseItem

func set_item(value:BaseItem):
	item = value
	_update()

func get_item() -> BaseItem:
	return item

## Utils
func _update():
	if item:
		_set_texture(item.texture)
		_set_count(1)
	else:
		_set_texture(null)
		_set_count(0)

func _set_texture(value:Texture2D):
	texture_rect.texture = value

func _set_count(value:int):
	if value <= 0:
		label_count.hide()
	else:
		label_count.show()
	label_count.text = str(value)
