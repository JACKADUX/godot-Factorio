extends InventorySlotUI

func _ready():
	super()
	_set_name(str(get_index()+1))

func set_slot(slot:Array[int]):
	_set_count(slot[1])
	_set_texture(DatatableManager.get_item_texture(slot[0]))
	
func set_empty():
	_set_count(0)
	_set_texture(null)
