class_name InventorySlot extends Resource

signal slot_changed

@export var item:BaseItem
@export var count:int = 0

## Interface
#region Base
func is_same_type(other:InventorySlot):
	if is_null() or other.is_null():
		return false
	return item.is_same_type(other.get_item())

func is_null():
	return item == null

func is_empty():
	return count <= 0

func set_item(value:BaseItem):
	if item != value:
		item = value
		slot_changed.emit()
		
func get_item():
	return item

func set_count(value:int):
	if count != value:
		count = value
		slot_changed.emit()

func get_count():
	return count

func change(_item:BaseItem, _count:int):
	item = _item
	count = _count
	slot_changed.emit()

func clear():
	item = null
	count = 0
	slot_changed.emit()

#endregion
#
func can_exchange(other_slot_ui:InventorySlot):
	return true

func exchange(other_slot:InventorySlot):
	var other_item = other_slot.get_item()
	var other_count = other_slot.get_count()
	other_slot.change(get_item(), get_count())
	change(other_item, other_count)

func can_stack(other_slot_ui:InventorySlot):
	if not is_same_type(other_slot_ui):
		return false
	return true

func stack_to(other_slot:InventorySlot):
	# self -> other_slot_ui
	other_slot.set_count(other_slot.get_count() + count)
	clear()

## Statics
static func create(item:BaseItem, count:int):
	var inventory_slot = InventorySlot.new()
	inventory_slot.change(item, count)
	return inventory_slot






