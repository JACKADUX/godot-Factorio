class_name InventorySlotUI extends Button

@onready var texture_rect = %TextureRect
@onready var label_count = %LabelCount
@onready var label_name = %LabelName

func _ready():
	set_empty()
		
## Interface
func set_slot(slot:Array[int]):
	_set_count(slot[1])
	_set_texture(DatatableManager.get_item_texture(slot[0]))
	_set_name(DatatableManager.get_item_name(slot[0]))

func set_empty():
	_set_count(0)
	_set_texture(null)
	_set_name("")

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
