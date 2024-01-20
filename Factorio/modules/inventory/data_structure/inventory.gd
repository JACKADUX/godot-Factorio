class_name Inventory extends Resource

var _slots :Array[InventorySlot]= []

## Interface
func get_slots() -> Array[InventorySlot]:
	return _slots

func get_slot_count() -> int:
	return _slots.size()

func get_slot(index:int) -> InventorySlot:
	return _slots[index]

func add_slot(value:InventorySlot):
	if not value in _slots:
		_slots.append(value)
	
func remove_slot(value:InventorySlot):
	if value in _slots:
		_slots.erase(value)

func stack_slot(slot:InventorySlot, other_slot:InventorySlot):
	pass

## Statics
static func create(number:int) -> Inventory:
	var inventory := Inventory.new()
	for i in number:
		inventory.add_slot(InventorySlot.new())
	return inventory
