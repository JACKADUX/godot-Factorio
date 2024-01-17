extends PanelContainer

signal pressed

@onready var button = %Button
@onready var texture_rect = %TextureRect
@onready var label_index = %LabelIndex

var _item:BaseItem

func _ready():
	button.pressed.connect(emit_signal.bind("pressed"))
	set_index(get_index()+1)
	
## Interface
func is_empty():
	return not _item

func get_item():
	return _item
	
func set_item(value:BaseItem):
	_item = value
	if not _item:
		texture_rect.hide()
		_set_name("")
	else:
		texture_rect.show()
		_set_texture(_item.texture) 
		_set_name(_item.name)

func set_index(value:int):
	label_index.text = str(value)

## Utils
func _set_name(value:String):
	tooltip_text = value

func _set_texture(value:Texture2D):
	texture_rect.texture = value
	
