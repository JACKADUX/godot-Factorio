extends InventorySlotUI


func update():
	_set_name(str(get_index()+1))
	if inventory_slot and inventory_slot.item:
		_set_count(inventory_slot.count)
		_set_texture(inventory_slot.item.texture)
	else:
		_set_count(0)
		_set_texture(null)
		
