extends InventoryUI

var player_inventory:PlayerInventory

func _ready():
	player_inventory = Globals.player_inventory
	player_inventory.invetory_changed.connect(func(): 
		player_inventory._auto_arrange()
		_update(player_inventory)
		)
	slot_pressed.connect(
		func(index):
			player_inventory.interact_with_hand_slot(player_inventory.get_slot(index), Globals.button_index)
	)
	_initialize(player_inventory)


