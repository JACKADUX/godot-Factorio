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

func get_item_count_data() -> Dictionary:
	""" { base_item : count } """
	var data := {}
	for slot:InventorySlot in _slots:
		var item :BaseItem = slot.get_item() 
		if not item:
			continue
		var key = item
		if not data.has(key):
			data[key] = 0
		data[key] += slot.get_count()
	return data
	

	
## Statics
static func create(number:int) -> Inventory:
	var inventory := Inventory.new()
	for i in number:
		inventory.add_slot(InventorySlot.new())
	return inventory
