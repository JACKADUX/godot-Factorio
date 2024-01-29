class_name Hotbar extends Inventory

signal hotbar_changed

func _feed_data():
	var Items = DatatableManager.base_items
	set_hotbar_item(0, Items.COAL)
	set_hotbar_item(1, Items.IRON_ORE)
	set_hotbar_item(2, Items.MINING_DRILL)
	set_hotbar_item(3, Items.IRON_CHEST)
	set_hotbar_item(4, Items.ASSEMBLING_MACHINE_1)
	
func set_hotbar_item(index:int, item:BaseItem):
	add_slot(InventorySlot.new(item, 0), index)
	hotbar_changed.emit()
	
func remove_hotbar_item(index:int):
	var slot = get_slot(index)
	remove_slot(slot)
	hotbar_changed.emit()
	
func update_hotbar(inventory:Inventory):
	var data = inventory.get_item_count_data()
	for slot:InventorySlot in _slots.values():
		var item = slot.get_item()
		var count = data[item] if data.has(item) else 0
		slot.set_count(count)
	
func interact_with_hotbar(index:int, hand_slot:HandSlot, inventory:Inventory):
	var slot:InventorySlot = get_slot(index)
	var _is_hand_empty = hand_slot.is_hand_empty()
	if not slot and _is_hand_empty:
		return 
	if not slot:
		if not _is_hand_empty:
			set_hotbar_item(index, hand_slot.get_item())
	else:
		var item = slot.get_item()
		if not _is_hand_empty:
			var hand_item = hand_slot.get_item()
			hand_slot.put_item_from_hand(inventory)
			if item != hand_item:
				hand_slot.take_item_to_hand(inventory, item)
		else: 
			hand_slot.take_item_to_hand(inventory, item)


## OnSignals
func _on_slot_changed(slot:InventorySlot):
	## NOTE: 覆写 Inventory, 保证数量为0的slot不被删除
	invetory_changed.emit()
		
