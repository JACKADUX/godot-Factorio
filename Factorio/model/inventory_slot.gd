class_name InventorySlot

signal slot_changed

var _item:BaseItem
var _count:int = 0

func _init(item:BaseItem, count:int):
	_item = item
	_count = count

## Interface
#region Base
func is_same_type(other:InventorySlot):
	return _item == other.get_item()

func is_empty():
	return _count <= 0

func set_item(value:BaseItem):
	if _item != value:
		_item = value
		slot_changed.emit()
		
func get_item() -> BaseItem:
	return _item

func set_count(value:int):
	if _count != value:
		_count = value
		slot_changed.emit()

func get_count() -> int:
	return _count

func change(item:BaseItem, count:int):
	_item = item
	_count = count
	slot_changed.emit()

func clear():
	## NOTE:持有当前 slot 的 inventory 会通过 slot_changed 信号自动将该对象清除
	set_count(0)

#endregion
func can_exchange(other_slot_ui:InventorySlot):
	if is_same_type(other_slot_ui):
		return false
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
	other_slot.set_count(other_slot.get_count() + _count)
	clear()

## Statics






