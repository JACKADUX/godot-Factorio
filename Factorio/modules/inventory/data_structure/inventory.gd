class_name Inventory extends Resource

signal invetory_changed
## FIXME: 空列表占用太多内存，需要其他方式存储！
@export var _slots :Array[InventorySlot]= []

## Interface
#region InventorySlot
func get_slots() -> Array[InventorySlot]:
	return _slots

func get_slot_count() -> int:
	return _slots.size()

func get_slot(index:int) -> InventorySlot:
	return _slots[index]

func add_slot(value:InventorySlot):
	if not value in _slots:
		_slots.append(value)
		value.slot_changed.connect(_on_slot_changed.bind(value))
		invetory_changed.emit()
	
func remove_slot(value:InventorySlot):
	if value in _slots:
		value.slot_changed.disconnect(_on_slot_changed.bind(value))
		_slots.erase(value)
		invetory_changed.emit()
		
#endregion
func add_item(item:BaseItem, count:int):
	count = max(0, count)
	for slot:InventorySlot in get_slots():
		var _item :BaseItem = slot.get_item() 
		if not _item:
			slot.change(item, count)
			return
		if _item.is_same_type(item):
			slot.set_count(slot.get_count()+count)
			return 

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

## Utils
func _auto_arrange():
	var count_data = get_item_count_data()
	var order_items = count_data.keys()
	order_items.sort_custom(func(a,b): return a.id < b.id)
	for slot:InventorySlot in get_slots():
		slot.item = null
		slot.count = 0
	
	for i in order_items.size():
		var slot := get_slot(i) as InventorySlot
		var item:BaseItem = order_items[i]
		slot.item = item
		slot.count = count_data[item]
	

## OnSignals
func _on_slot_changed(value:InventorySlot):
	invetory_changed.emit()

## Statics
static func create(number:int) -> Inventory:
	var inventory := Inventory.new()
	for i in number:
		inventory.add_slot(InventorySlot.new())
	return inventory
