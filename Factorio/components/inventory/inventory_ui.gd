class_name InventoryUI extends GridContainer

signal slot_pressed(index:int)

@export var INVENTORY_SLOT_UI_PACKED :PackedScene

## Utils
func _initialize(inventory:Inventory):
	var count = inventory.size()
	# clear
	for child in get_children():
		remove_child(child)
		child.queue_free()
	# add
	for i in count:
		var slot_ui := INVENTORY_SLOT_UI_PACKED.instantiate() as InventorySlotUI
		add_child(slot_ui)
		slot_ui.pressed.connect(func():slot_pressed.emit(slot_ui.get_index()))
	# update
	_update(inventory)

func _update(inventory:Inventory):
	var count = inventory.size()
	if count != get_children().size():
		_initialize(inventory)
		return 
	for index in count:
		var slot_ui = get_child(index) as InventorySlotUI
		var slot = inventory.get_slot(index)
		if not slot:
			slot_ui.set_empty()
		else:
			slot_ui.set_slot(slot)























