class_name InventoryUI extends GridContainer

signal inventory_changed

@export var INVENTORY_SLOT_UI_PACKED :PackedScene

var _inventory := Inventory.new()
 
## Interface
func add_item(item:BaseItem, count:int):
	count = max(0, count)
	for slot:InventorySlotUI in get_slots():
		var _item :BaseItem = slot.get_item() 
		if not _item:
			slot.change(item, count)
			return
		if _item.is_same_type(item):
			slot.set_count(slot.get_count()+count)
			return 

func get_item_count_data() -> Dictionary:
	""" { base_item : count } """
	return _inventory.get_item_count_data()

func get_slots():
	return get_children()

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
		var slot_ui := INVENTORY_SLOT_UI_PACKED.instantiate() as InventorySlotUI
		add_child(slot_ui)
		slot_ui.slot_changed.connect(_on_slot_changed.bind(slot_ui))
		slot_ui.pressed.connect(_on_slot_pressed.bind(slot_ui))


## OnSignal
func _on_slot_pressed(slot_ui:InventorySlotUI):
	Globals.inventory_slot_clicked.emit(self, slot_ui)

func _on_slot_changed(slot_ui:InventorySlotUI):
	inventory_changed.emit()






















