class_name PlayerInventory extends Inventory

signal hand_slot_changed
signal hotbar_changed

var hand_slot :InventorySlot:
	set(value):
		hand_slot = value
		if hand_slot:
			hand_slot.slot_changed.connect(emit_signal.bind("hand_slot_changed"))
		hand_slot_changed.emit()
		
var hotbar :Array[InventorySlot] = []

func _init(slot_number:int=0):
	super(slot_number)
	initialize_hotbar(10)
	
func _feed_data():
	var Items = DatatableManager.base_items
	add_item(Items.COAL, 12)
	add_item(Items.IRON_ORE, 8)
	add_item(Items.MINING_DRILL, 2)
	add_item(Items.IRON_CHEST, 2)
	add_item(Items.ASSEMBLING_MACHINE_1, 2)
	set_hotbar_item(0, Items.COAL)
	set_hotbar_item(1, Items.IRON_ORE)
	set_hotbar_item(2, Items.MINING_DRILL)
	set_hotbar_item(3, Items.IRON_CHEST)
	set_hotbar_item(4, Items.ASSEMBLING_MACHINE_1)
	_auto_arrange()
	emit_signal("invetory_changed")
	
## Interface
func initialize_hotbar(size:int):
	hotbar.resize(size)
	hotbar.fill(null)

func set_hotbar_item(index:int, item:BaseItem):
	assert( 0<= index and index < hotbar.size())
	hotbar[index] = InventorySlot.new(item, 0)
	hotbar_changed.emit()
	
func remove_hotbar_item(index:int):
	assert( 0<= index and index < hotbar.size())
	hotbar[index] = null
	hotbar_changed.emit()

func get_hotbar():
	var data = get_item_count_data()
	for slot:InventorySlot in hotbar:
		if not slot:
			continue
		var item = slot.get_item()
		var count = data[item] if data.has(item) else 0
		slot.set_count(count)
	return hotbar

func is_hand_empty():
	return not hand_slot

func take_item_to_hand(inventroy:Inventory, item:BaseItem):
	if not item or not is_hand_empty():
		return 
	var slot = inventroy.get_slot_with(item)
	if not slot:
		return 
	hand_slot = InventorySlot.new(slot.get_item(), slot.get_count())
	slot.clear()
			
func put_item_from_hand(inventroy:Inventory):
	if not hand_slot:
		return 
	inventroy.add_item(hand_slot.get_item(), hand_slot.get_count())
	hand_slot = null
	
func interact_with_hand_slot(inventory:Inventory, index:int):
	var slot:InventorySlot = inventory.get_slot(index)
	if not hand_slot and not slot:
		return 
	elif not hand_slot:
		hand_slot = InventorySlot.new(slot.get_item(), slot.get_count())
		slot.clear()
	elif not slot:
		var new_slot = InventorySlot.new(hand_slot.get_item(), hand_slot.get_count())
		inventory.add_slot(new_slot, index)
		hand_slot = null
	else:
		if hand_slot.can_exchange(slot):
			hand_slot.exchange(slot)
		elif hand_slot.can_stack(slot):
			hand_slot.stack_to(slot)
			hand_slot = null

func interact_with_hotbar(index:int):
	var slot:InventorySlot = hotbar[index]
	var _is_hand_empty = is_hand_empty()
	if not slot and _is_hand_empty:
		return 
	if not slot:
		if not _is_hand_empty:
			set_hotbar_item(index, hand_slot.get_item())
	else:
		var item = slot.get_item()
		if not _is_hand_empty:
			var hand_item = hand_slot.get_item()
			put_item_from_hand(self)
			if item != hand_item:
				take_item_to_hand(self, item)
		else: 
			take_item_to_hand(self, item)

## Utils
func _auto_arrange():
	_sort(func(a,b):
			return DatatableManager.get_item_type(a.id) < DatatableManager.get_item_type(b.id)
	)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
