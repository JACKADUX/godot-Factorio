class_name HandSlot extends InventorySlot

func _init(item:BaseItem=null, count:int=0):
	super(item, count)

func is_hand_empty():
	return get_count() <= 0 or not get_item()

func take_item_to_hand(inventroy:Inventory, item:BaseItem, count:int=-1) -> bool:
	## 当 count == -1 时，会转移所有数量
	if not item or not is_hand_empty():
		return false
	var slot = inventroy.get_slot_with(item)
	if not slot:
		return false
	if slot.is_empty():
		return false
	var item_count = slot.get_count()
	if count < 0:
		count = item_count
	count = clamp(count, 0, item_count)
	item_count -= count
	## FIXME: 这里还需要检查上限 （交给未来的自己
	change(slot.get_item(), count)
	slot.set_count(item_count)
	return true
			
func put_item_from_hand(inventroy:Inventory, count:int=-1) -> bool:
	## 当 count == -1 时，会转移所有数量
	if is_hand_empty():
		return false
	var item_count = get_count()
	if count < 0:
		count = item_count
	count = clamp(count, 0, item_count)
	item_count -= count
	## FIXME: 这里还需要检查上限 （交给未来的自己
	inventroy.add_item(get_item(), count)
	set_count(item_count)
	return true
	
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

func handle_input_click_event(index:int, inventory:Inventory):
	## NOTE:此方法用于处理与slot交互时的事件
	match Globals.button_index:
		MOUSE_BUTTON_LEFT:
			interact_with_hand_slot(inventory, index)






