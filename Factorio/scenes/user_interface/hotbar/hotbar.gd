class_name Hotbar extends Inventory

signal hotbar_changed

func _init(number:int=0) :
	super(number)
	remove_empty_slot = false

func _feed_data():
	var Items = DatatableManager.base_items
	set_hotbar_item(0, Items.COAL)
	set_hotbar_item(1, Items.IRON_ORE)
	set_hotbar_item(2, Items.MINING_DRILL)
	set_hotbar_item(3, Items.IRON_CHEST)
	set_hotbar_item(4, Items.ASSEMBLING_MACHINE_1)
	set_hotbar_item(5, Items.INSERTER_1)
	
func set_hotbar_item(index:int, item_id:String):
	add_slot(InventorySlot.new(item_id, 0), index)
	hotbar_changed.emit()
	
func remove_hotbar_item(index:int):
	var slot = get_slot(index)
	remove_slot(slot)
	hotbar_changed.emit()
	
func update_hotbar(inventory:Inventory):
	var data = inventory.get_amount_data()
	for slot:InventorySlot in get_valid_slots():
		var item = slot.get_id()
		var amount = data[item] if data.has(item) else 0
		slot.set_amount(amount)
	
func interact_with_hotbar(index:int, hand_inventory:Inventory, inventory:Inventory):
	var hotbar_slot:InventorySlot = get_slot(index)
	var hand_slot:InventorySlot = hand_inventory.get_slot(0)
	if not hotbar_slot and not hand_slot:
		return 
	elif not hotbar_slot:
		set_hotbar_item(index, hand_slot.get_id())
	elif not hand_slot:
		Inventory.transfer(inventory, hotbar_slot.get_id(), -1, hand_inventory)
	else:
		Inventory.transfer(hand_inventory, hand_slot.get_id(), -1, inventory)
		if not hotbar_slot.is_same_id(hand_slot):
			Inventory.transfer(inventory, hotbar_slot.get_id(), -1, hand_inventory)

			
			
