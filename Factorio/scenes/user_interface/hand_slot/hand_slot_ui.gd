extends InventorySlotUI

func _process(delta):
	if visible:
		global_position = get_global_mouse_position()

func _initialize(slot:HandSlot):
	_update(slot)
	
func _update(slot:HandSlot):
	if slot.is_hand_empty():
		set_empty()
	else:
		set_slot(slot)

## Interface
func set_slot(slot:InventorySlot):
	show()
	_set_count(slot.get_count())
	_set_texture(slot.get_item().texture)
		
func set_empty():
	hide()
	_set_count(0)
	_set_texture(null)