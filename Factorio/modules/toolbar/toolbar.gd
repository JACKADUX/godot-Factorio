extends PanelContainer

@export var display:Display
@onready var h_box_container = %HBoxContainer

enum State {Setting, Use}
var _state := State.Setting

func _ready():
	for tb_slot in h_box_container.get_children():
		tb_slot.pressed.connect(_on_toolbar_slot_pressed.bind(tb_slot))
	_feed_data.call_deferred()

func _feed_data():
	display.set_item(InventoryItem.create_from(Items.COAL))
	#var slot = _get_toolbar_slot(1)
	#slot.set_item(Items.COAL)
	#slot = _get_toolbar_slot(2)
	#slot.set_item(Items.IRON_ORE)
	

## Utils
func _get_toolbar_slot(index:int):
	return h_box_container.get_child(index-1)

func _on_toolbar_slot_pressed(slot):
	var _item = display.get_item()
	if _item:
		slot.set_item(_item.item)
		return 
	if not slot.is_empty():
		display.set_item(InventoryItem.create_from(slot.get_item()))
