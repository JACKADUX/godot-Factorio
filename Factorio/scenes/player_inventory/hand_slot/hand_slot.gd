extends InventorySlotUI


func _ready():
	Globals.inventory_slot_clicked.connect(_on_inventory_slot_clicked)
	update()
	
func _feed_data():
	inventory_slot = InventorySlot.new()
	inventory_slot.change(Items.IRON_ORE, 2)
	update()

func _process(delta):
	if inventory_slot:
		global_position = get_global_mouse_position()


func update():
	if inventory_slot and inventory_slot.item:
		show()
		_set_count(inventory_slot.count)
		_set_texture(inventory_slot.item.texture)
	else:
		hide()
		_set_count(0)
		_set_texture(null)

func _on_inventory_slot_clicked(inventory_ui:InventoryUI, slot_ui:InventorySlotUI):
	if Globals.button_index == MOUSE_BUTTON_LEFT:
		if can_stack(slot_ui):
			stack_to(slot_ui)
		elif can_exchange(slot_ui):
			exchange(slot_ui)
		
	elif Globals.button_index == MOUSE_BUTTON_RIGHT:
		pass
		
