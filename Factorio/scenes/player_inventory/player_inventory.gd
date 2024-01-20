extends InventoryUI

# Called when the node enters the scene tree for the first time.
func _ready():
	_feed_data()
	_initialize()

func _feed_data():
	_inventory = _inventory.create(16)
	_inventory.get_slot(2).change(Items.COAL, 12)
	_inventory.get_slot(4).change(Items.COAL, 8)
	_inventory.get_slot(7).change(Items.IRON_ORE, 2)
