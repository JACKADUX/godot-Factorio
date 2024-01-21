extends HBoxContainer

@export var player_inventory:InventoryUI
@export var hand_slot:InventorySlotUI


func _ready():
	for tb_slot_ui in get_children():
		tb_slot_ui.pressed.connect(_on_toolbar_slot_pressed.bind(tb_slot_ui))
	player_inventory.inventory_changed.connect(_on_player_inventory_changed)
	hand_slot.slot_changed.connect(_on_hand_slot_changed)
	_feed_data.call_deferred()
	
func _feed_data():
	var slot = _get_toolbar_slot(1)
	slot.set_item(Items.COAL)
	_update()
	
### Utils
func _get_toolbar_slot(index:int) -> InventorySlotUI:
	return get_child(index-1)
#
func _on_toolbar_slot_pressed(tb_slot_ui:InventorySlotUI):
	var tb_item :BaseItem = tb_slot_ui.get_item()
	var hand_item :BaseItem = hand_slot.get_item()
	if Globals.button_index == MOUSE_BUTTON_LEFT:
		if not tb_item and hand_item:
			tb_slot_ui.set_item(hand_slot.get_item())
		else:
			player_inventory.hold_item(tb_item)  
	elif Globals.button_index == MOUSE_BUTTON_MIDDLE:
		tb_slot_ui.clear()
		tb_slot_ui.button_pressed = false
	_update()
	
func _update():
	var hand = 0
	var inventory_count = 0
	var count_data = player_inventory.get_item_count_data()
	for tb_slot_ui:InventorySlotUI in get_children():
		var tb_item : BaseItem = tb_slot_ui.get_item()
		if not tb_item:
			continue
			
		if tb_slot_ui.is_same_type(hand_slot):
			hand = hand_slot.get_count()
		else:
			hand = 0
			
		if not count_data.has(tb_item):
			inventory_count = 0
		else:
			inventory_count = count_data[tb_item]
				
		tb_slot_ui.set_count(inventory_count+ hand)

## OnSignals
func _on_player_inventory_changed():
	_update()
	
func _on_hand_slot_changed():
	_update()









	
