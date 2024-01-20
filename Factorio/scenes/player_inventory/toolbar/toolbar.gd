extends HBoxContainer


func _ready():
	for tb_slot in get_children():
		tb_slot.pressed.connect(_on_toolbar_slot_pressed.bind(tb_slot))
	#_feed_data.call_deferred()

func _feed_data():
	var slot = _get_toolbar_slot(1)
	slot.inventory_slot = InventorySlot.new()
	slot.inventory_slot.change(Items.IRON_ORE, 5)
	slot.update()
	
### Utils
func _get_toolbar_slot(index:int):
	return get_child(index-1)
#
func _on_toolbar_slot_pressed(tb_slot):
	pass
	#var _item = display.get_item()
	#if _item:
		#slot.set_item(_item.item)
		#return 
	#if not slot.is_empty():
		#display.set_item(InventoryItem.create_from(slot.get_item()))
