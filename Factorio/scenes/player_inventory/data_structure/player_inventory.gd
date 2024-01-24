class_name PlayerInventory extends Inventory

signal hand_slot_changed
signal hotbar_changed

var hand_slot := InventorySlot.new()
var hotbar :Array[BaseItem] = []

func _init():
	hand_slot.slot_changed.connect(emit_signal.bind("hand_slot_changed"))
	initialize_hotbar(10)
	_feed_data.call_deferred()
	
func _feed_data():
	get_slot(2).change(Items.COAL, 12)
	get_slot(4).change(Items.COAL, 8)
	get_slot(7).change(Items.IRON_ORE, 2)
	change_hotbar_item(5, Items.COAL)
	_auto_arrange()
	emit_signal("invetory_changed")
	
## Interface
func initialize_hotbar(size:int):
	hotbar.resize(size)
	hotbar.fill(null)

func change_hotbar_item(index:int, item:BaseItem):
	assert( 0<= index and index < hotbar.size())
	hotbar[index] = item
	hotbar_changed.emit()

func get_hotbar_slots() -> Array[InventorySlot]:
	var data = get_item_count_data()
	var inventory_slots :Array[InventorySlot] = []
	for item in hotbar:
		var count = 0
		if not item:
			inventory_slots.append(null)
			continue
		if data.has(item):
			count = data[item]
		inventory_slots.append(InventorySlot.create(item, count))
	return inventory_slots

func hold_item(value:BaseItem):
	if not value:
		return 
	for slot:InventorySlot in get_slots():
		var item :BaseItem = slot.get_item()
		if not item:
			continue
		if item.is_same_type(value):
			interact_with_hand_slot(slot)
			return

func interact_with_hand_slot(slot:InventorySlot, flag:int=0):
	if hand_slot.is_null() and slot.is_null():
		return 
	if hand_slot.can_exchange(slot):
		hand_slot.exchange(slot)
	elif hand_slot.can_stack(slot):
		hand_slot.stack_to(slot)

func interact_with_hotbar(index:int, flag:int=0):
	var item:BaseItem = hotbar[index]
	if flag == 3:
		change_hotbar_item(index, null)
		return 
	if not item and hand_slot.is_null():
		return 
	elif not item:
		change_hotbar_item(index, hand_slot.get_item())
		return 
	elif item.is_same_type(hand_slot.item):
		add_item(hand_slot.item, hand_slot.count)
		hand_slot.clear()
		return 
	hold_item(item)
	

## Statics
static func create(number:int) -> PlayerInventory:
	var inventory := PlayerInventory.new()
	for i in number:
		inventory.add_slot(InventorySlot.new())
	return inventory
	
