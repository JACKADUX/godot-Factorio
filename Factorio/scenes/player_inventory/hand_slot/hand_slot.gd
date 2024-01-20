extends InventorySlotUI

var mouse_click := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.inventory_slot_clicked.connect(_on_inventory_slot_clicked)
	update()

func _feed_data():
	inventory_slot = InventorySlot.new()
	inventory_slot.change(Items.IRON_ORE, 2)
	update()

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_click = 1
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		mouse_click = 2
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		mouse_click = 3
	else:
		mouse_click = 0
		
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
	if mouse_click == 1:
		if can_stack(slot_ui):
			stack_to(slot_ui)
		elif can_exchange(slot_ui):
			exchange(slot_ui)
	elif mouse_click == 2:
		pass
		
