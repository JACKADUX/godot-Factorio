extends InventorySlotUI

func _process(delta):
	if visible:
		global_position = get_global_mouse_position()

func _initialize(inventory:Inventory):
	_update(inventory)
	
func _update(inventory:Inventory):
	var slots = inventory.get_slots()
	if not slots:
		set_empty()
	else:
		set_slot(slots[0])

## Interface
func set_slot(slot:Array[int]):
	show()
	_set_count(slot[1])
	_set_texture(DatatableManager.get_item_texture(slot[0]))
		
func set_empty():
	hide()
	_set_count(0)
	_set_texture(null)
