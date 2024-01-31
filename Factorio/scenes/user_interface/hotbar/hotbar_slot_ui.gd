extends InventorySlotUI

func _ready():
	super()
	_set_name(str(get_index()+1))

func set_slot(slot:InventorySlot):
	_set_count(slot.get_amount())
	_set_texture(DatatableManager.get_item_texture(slot.get_id()))
	
func set_empty():
	_set_count(0)
	_set_texture(null)
