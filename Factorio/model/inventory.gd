class_name Inventory

signal invetory_changed

var _slots :Array[InventorySlot]= []

## Statics
func _init(number:int=0) :
	_slots.resize(number)

## Interface
# ----------------- slots
func get_slots() -> Array[InventorySlot]:
	return _slots

func get_slot_count() -> int:
	return _slots.size()

func get_slot(index:int) -> InventorySlot:
	return _slots[index]
	
func get_slot_with(item:BaseItem) -> InventorySlot:
	for slot:InventorySlot in _slots:
		if not slot:
			continue
		if slot.get_item() == item:
			return slot
	return null

func add_slot(value:InventorySlot, index:int):
	if value in _slots or _slots[index]:
		return 
	_slots[index] = value
	value.slot_changed.connect(_on_slot_changed.bind(value))
	invetory_changed.emit()
		
func remove_slot(value:InventorySlot):
	var index = _slots.find(value)
	if index == -1:
		return 
	value.slot_changed.disconnect(_on_slot_changed.bind(value))
	_slots[index] = null
	invetory_changed.emit()
	
# ----------------- other
func get_item_count_data() -> Dictionary:
	""" { base_item : count } """
	var data := {}
	for slot:InventorySlot in _slots:
		if not slot:
			continue
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
	var number = _slots.size()
	_slots = []
	for i in order_items.size():
		var item:BaseItem = order_items[i]
		var slot = InventorySlot.new(item, count_data[item])
		slot.slot_changed.connect(_on_slot_changed.bind(slot))
		_slots.append(slot)
	_slots.resize(number)
	
func _get_first_null_index() -> int:
	## return -1 if don't have any null
	for index in _slots.size():
		if _slots[index] == null:
			return index
	return -1
	
## OnSignals
func _on_slot_changed(slot:InventorySlot):
	if slot.is_empty():
		remove_slot(slot)
	else:
		invetory_changed.emit()




















