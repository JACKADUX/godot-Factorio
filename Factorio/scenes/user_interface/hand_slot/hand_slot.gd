class_name HandSlot extends InventorySlot

signal hand_slot_changed

func _init(item:BaseItem=null, count:int=0):
	super(item, count)
	slot_changed.connect(emit_signal.bind("hand_slot_changed"))

func is_hand_empty():
	return get_count() <= 0 or not get_item()

func take_item_to_hand(inventroy:Inventory, item:BaseItem):
	if not item or not is_hand_empty():
		return 
	var slot = inventroy.get_slot_with(item)
	if not slot:
		return 
	change(slot.get_item(), slot.get_count())
	slot.clear()
			
func put_item_from_hand(inventroy:Inventory):
	if is_hand_empty():
		return 
	inventroy.add_item(get_item(), get_count())
	clear()
	
func interact_with_hand_slot(inventory:Inventory, index:int):
	var slot:InventorySlot = inventory.get_slot(index)
	if is_hand_empty() and not slot:
		return 
	elif is_hand_empty():
		change(slot.get_item(), slot.get_count())
		slot.clear()
	elif not slot:
		var new_slot = InventorySlot.new(get_item(), get_count())
		inventory.add_slot(new_slot, index)
		clear()
	else:
		if can_exchange(slot):
			exchange(slot)
		elif can_stack(slot):
			stack_to(slot)
			clear()

