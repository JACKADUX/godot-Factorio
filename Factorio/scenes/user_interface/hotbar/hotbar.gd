class_name Hotbar extends Inventory

signal hotbar_changed

func _init(number:int=0):
	super(number)

func _feed_data():
	var Items = DatatableManager.base_items
	set_hotbar_item(1, Items.COAL)
	set_hotbar_item(2, Items.IRON_ORE)
	set_hotbar_item(3, Items.INSERTER_1)
	set_hotbar_item(4, Items.TRANSPORT_BELT_1)
	set_hotbar_item(5, Items.IRON_CHEST)
	set_hotbar_item(8, Items.MINING_DRILL)
	
func set_hotbar_item(index:int, id:int):
	override_slot(index, id, 1)
	hotbar_changed.emit()
	
func remove_hotbar_item(index:int):
	remove_slot(index)
	hotbar_changed.emit()
	
func update_hotbar(inventory:Inventory):
	var data = inventory.get_amount_data()
	for slot in get_slots():
		var id = slot[0]
		var amount = data[id] if data.has(id) else 0
		slot[1] = amount
	
func interact_with_hotbar(index:int, hand_inventory:Inventory, inventory:Inventory):
	var hotbar_slot:Array[int] = get_slot(index)
	var hand_slot:Array[int] = hand_inventory.get_slot(0)
	if not hotbar_slot and not hand_slot:
		return 
	elif not hotbar_slot:
		set_hotbar_item(index, hand_slot[0])
	elif not hand_slot:
		Inventory.transfer(inventory, hotbar_slot[0], -1, hand_inventory)
	else:
		Inventory.transfer(hand_inventory, hand_slot[0], -1, inventory)
		if hotbar_slot[0] != hand_slot[0]:
			Inventory.transfer(inventory, hotbar_slot[0], -1, hand_inventory)

			
			
