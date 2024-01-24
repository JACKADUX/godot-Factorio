extends InventorySlotUI

func _ready():
	var player_inventory = Globals.player_inventory
	player_inventory.hand_slot_changed.connect(func():
		if not player_inventory.hand_slot.is_null():
			set_slot(player_inventory.hand_slot)
		else:
			set_empty()
		)
	set_empty()

func _process(delta):
	if visible:
		global_position = get_global_mouse_position()

## Interface
func set_slot(slot:InventorySlot):
	show()
	_set_count(slot.count)
	_set_texture(slot.item.texture)
		
func set_empty():
	hide()
	_set_count(0)
	_set_texture(null)
