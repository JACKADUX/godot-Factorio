class_name Inventory

signal inventory_changed

## auto remove slot when slot.is_empty() is true
var remove_empty_slot:=true

var _size :int = 0
var _valid_slots_data := {}

func _init(inventory_size:int=0) :
	_size = inventory_size

## Interface
# ----------------- slots
func get_valid_slots() -> Array:
	# Array[InventorySlot]
	return _valid_slots_data.values()
	
func get_all_slots() -> Array[InventorySlot]:
	var array_slots :Array[InventorySlot] = [] 
	array_slots.resize(_size)
	for i in _valid_slots_data:
		array_slots[i] = _valid_slots_data[i]
	return array_slots

func size() -> int:
	return _size

func has_slot(index:int)->bool:
	return index in _valid_slots_data.keys()

func get_slot(index:int) -> InventorySlot:
	return _valid_slots_data.get(index)

func find_slots(id:String, keep_empty:=false) -> Array:
	var _finds = []
	for slot in get_valid_slots():
		if slot.get_id() != id:
			continue
		if not keep_empty and slot.get_amount() <= 0:
			continue
		_finds.append(slot)
			
	return _finds

func add_slot(value:InventorySlot, index:int) -> bool:
	if value in get_valid_slots() or _valid_slots_data.has(index):
		return false
	_valid_slots_data[index] = value
	value.slot_changed.connect(_on_slot_changed.bind(value))
	inventory_changed.emit()
	return true
		
func remove_slot(value:InventorySlot) -> bool:
	var index = _valid_slots_data.find_key(value)
	if index == null:
		return false
	value.slot_changed.disconnect(_on_slot_changed.bind(value))
	_valid_slots_data.erase(index)
	inventory_changed.emit()
	return true

# ----------------- other
func get_amount_data() -> Dictionary:
	""" { id : amount } """
	var data := {}
	for slot:InventorySlot in get_valid_slots():
		var id := slot.get_id() 
		if not data.has(id):
			data[id] = 0
		data[id] += slot.get_amount()
	return data

func input(id:String, amount:int)->bool:
	amount = max(0, amount)
	for index in size():
		var slot:InventorySlot = get_slot(index)
		if not slot:
			add_slot(InventorySlot.new(id, amount), index)
			return true
		if slot.get_id() == id:
			slot.set_amount(slot.get_amount()+amount)
			return true
	return false



## Utils
func _sort(sort_callable:Callable):
	# sort_callable = func(a,b): return a < b
	var amount_data = get_amount_data()
	var order_items = amount_data.keys()
	order_items.sort_custom(sort_callable)
	_valid_slots_data = {}
	for i in order_items.size():
		var item_id:String = order_items[i]
		var slot = InventorySlot.new(item_id, amount_data[item_id])
		slot.slot_changed.connect(_on_slot_changed.bind(slot))
		_valid_slots_data[i] = slot

	
## OnSignals
func _on_slot_changed(slot:InventorySlot):
	if slot.is_empty() and remove_empty_slot:
		remove_slot(slot)
	else:
		inventory_changed.emit()


## Statics
static func interact(inventory:Inventory, index:int, other_inventory:Inventory, other_index:int) -> bool:
	var slot: InventorySlot = inventory.get_slot(index)
	var other_slot:InventorySlot = other_inventory.get_slot(other_index)
	if not slot and not other_slot:
		return false
	elif not slot:	
		slot = InventorySlot.new(other_slot.get_id(), other_slot.get_amount())
		inventory.add_slot(slot, index)
		other_slot.clear()
	elif not other_slot:
		other_slot = InventorySlot.new(slot.get_id(), slot.get_amount())
		other_inventory.add_slot(other_slot, other_index)
		slot.clear()
	else:
		if slot.can_exchange(other_slot):
			slot.exchange(other_slot)
		elif slot.can_stack(other_slot):
			slot.stack_to(other_slot)
	return true
	
static func transfer(from_inventroy:Inventory, id:String, request_amount:int, to_inventory:Inventory):
	## 当 request_amount < 0 时， request_amount 就等于第一个 id slot 的 amount
	if request_amount == 0:
		return 
	var slots = from_inventroy.find_slots(id)
	if not slots:
		return 
	if request_amount < 0:
		request_amount = slots[0].get_amount()
		 
	for slot:InventorySlot in slots:
		var amount = slot.get_amount()
		var transfer_amount = request_amount if request_amount < amount else amount
		request_amount -= transfer_amount
		var res = to_inventory.input(id, transfer_amount)
		if not res:
			break
		slot.set_amount(amount-transfer_amount)
		if request_amount <= 0:
			break
















