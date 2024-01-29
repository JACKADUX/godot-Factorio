class_name Inventory

signal invetory_changed

var _size :int = 0
var _slots := {}

func _init(number:int=0) :
	_size = number

## Interface
# ----------------- slots
func get_slots() -> Array[InventorySlot]:
	var array_slots :Array[InventorySlot] = [] 
	array_slots.resize(_size)
	for i in _slots:
		array_slots[i] = _slots[i]
	return array_slots

func get_slot_count() -> int:
	return _size

func get_slot(index:int) -> InventorySlot:
	return _slots.get(index)
	
func get_slot_with(item:BaseItem) -> InventorySlot:
	for slot:InventorySlot in _slots.values():
		if slot.get_item() == item:
			return slot
	return null

func add_slot(value:InventorySlot, index:int):
	if value in _slots.values() or _slots.has(index):
		return 
	_slots[index] = value
	value.slot_changed.connect(_on_slot_changed.bind(value))
	invetory_changed.emit()
		
func remove_slot(value:InventorySlot):
	var index = _slots.find_key(value)
	if index == null:
		return 
	value.slot_changed.disconnect(_on_slot_changed.bind(value))
	_slots.erase(index)
	invetory_changed.emit()
	
# ----------------- other
func get_item_count_data() -> Dictionary:
	""" { base_item : count } """
	var data := {}
	for slot:InventorySlot in _slots.values():
		var item :BaseItem = slot.get_item() 
		if not data.has(item):
			data[item] = 0
		data[item] += slot.get_count()
	return data

func add_item(item:BaseItem, count:int):
	count = max(0, count)
	for index in get_slot_count():
		var slot:InventorySlot = get_slot(index)
		if not slot:
			add_slot(InventorySlot.new(item, count), index)
			return
		if slot.get_item() == item:
			slot.set_count(slot.get_count()+count)
			return 

		
## Utils
func _sort(sort_callable:= Callable()):
	var count_data = get_item_count_data()
	var order_items = count_data.keys()
	if not sort_callable:
		sort_callable = func(a,b): return a.id < b.id
	order_items.sort_custom(sort_callable)
	_slots = {}
	for i in order_items.size():
		var item:BaseItem = order_items[i]
		var slot = InventorySlot.new(item, count_data[item])
		slot.slot_changed.connect(_on_slot_changed.bind(slot))
		_slots[i] = slot

	
## OnSignals
func _on_slot_changed(slot:InventorySlot):
	if slot.is_empty():
		remove_slot(slot)
	else:
		invetory_changed.emit()




















