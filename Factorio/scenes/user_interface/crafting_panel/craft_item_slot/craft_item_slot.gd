class_name CraftItemSlot extends Button

@onready var texture_rect = %TextureRect
@onready var label_count = %LabelCount


func set_item(id:int, count:int):
	_set_texture(DatatableManager.get_item_texture(id))
	_set_count(count)

func set_empty():
	_set_texture(null)
	_set_count(0)
		
## Utils
func _set_texture(value:Texture2D):
	texture_rect.texture = value

func _set_count(value:int):
	if value <= 0:
		label_count.hide()
	else:
		label_count.show()
	label_count.text = str(value)
