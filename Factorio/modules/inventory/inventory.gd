extends Control

@export var display:Display
@export var  INVENTORY_SLOT_PACKED :PackedScene
@onready var grid_container = %GridContainer

var _inventory_data := InventoryData.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_feed_data()
	_initialize()

func _feed_data():
	var inventory_item = InventoryItem.new()
	inventory_item.item = Items.COAL
	inventory_item.count = 12
	inventory_item.slot_index = 5
	_inventory_data.add_inventory_item(inventory_item)
	
	inventory_item = inventory_item.duplicate()
	inventory_item.count = 4
	inventory_item.slot_index = 8
	_inventory_data.add_inventory_item(inventory_item)
	
	inventory_item = inventory_item.duplicate()
	inventory_item.item = Items.IRON_ORE
	inventory_item.count = 5
	inventory_item.slot_index = 2
	_inventory_data.add_inventory_item(inventory_item)
	
## Utils
func _initialize():
	_create_slot(16, 4)
	for inventory_item:InventoryItem in _inventory_data.get_inventory_items():
		var slot = grid_container.get_child(inventory_item.slot_index)
		slot.put_inventory_item(inventory_item)

func _create_slot(number, columns):
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()
	grid_container.columns = columns
	for i in range(number):
		var slot = INVENTORY_SLOT_PACKED.instantiate()
		grid_container.add_child(slot)
		slot.pressed.connect(_on_slot_pressed.bind(slot))

func _put_item_to_slot(slot:InventorySlot, inventory_item:InventoryItem):
	_inventory_data.add_inventory_item(inventory_item)
	inventory_item.slot_index = slot.get_index()
	slot.put_inventory_item(inventory_item)
	
func _take_item_from_slot(slot:InventorySlot):
	var inventory_item = slot.take_inventory_item()
	inventory_item.slot_index = -1
	_inventory_data.remove_inventory_item(inventory_item)
	return inventory_item
	

## OnSignal
func _on_slot_pressed(slot:InventorySlot):
	var _grabed_item = display.get_item()
	if slot.is_empty():
		if _grabed_item:
			_put_item_to_slot(slot, _grabed_item)
			display.clear_item()
	else:
		if not _grabed_item:
			display.set_item(_take_item_from_slot(slot))
		else:
			var _prev_grab = _grabed_item
			var _new_grab = _take_item_from_slot(slot)
			if _prev_grab.id == _new_grab.id:
				_prev_grab = _inventory_data.merge_inventory_item(_prev_grab, _new_grab)
				_put_item_to_slot(slot, _prev_grab)
				display.clear_item()
			else:
				_put_item_to_slot(slot, _prev_grab)
				display.set_item(_new_grab)
	
	
