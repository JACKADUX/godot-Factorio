class_name InventoryUI extends GridContainer

@export var  INVENTORY_SLOT_UI_PACKED :PackedScene

var _inventory := Inventory.new()
 
## Utils
func _initialize():
	var count = _inventory.get_slot_count()
	_create_slot(count, columns)
	for index in count:
		var slot_ui = get_child(index)
		var slot = _inventory.get_slot(index)
		slot_ui.inventory_slot = slot
		slot_ui.update()
		
func _clear_slots():
	for child in get_children():
		remove_child(child)
		child.queue_free()

func _create_slot(number, columns):
	_clear_slots()
	for i in number:
		var slot_ui = INVENTORY_SLOT_UI_PACKED.instantiate()
		add_child(slot_ui)
		slot_ui.pressed.connect(_on_slot_pressed.bind(slot_ui))


## OnSignal
func _on_slot_pressed(slot_ui:InventorySlotUI):
	Globals.inventory_slot_clicked.emit(self, slot_ui)
	
