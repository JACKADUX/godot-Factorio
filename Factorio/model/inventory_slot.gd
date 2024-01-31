class_name InventorySlot

signal slot_changed

var _id:String=""
var _amount:int = 0

func _init(id:String="", amount:int=0):
	_id = id
	_amount = amount

## Interface
#region Base
func is_same_id(other:InventorySlot):
	return _id == other.get_id()

func is_empty():
	return _amount <= 0 or not _id

func set_id(value:String):
	if _id != value:
		_id = value
		slot_changed.emit()
		
func get_id() -> String:
	return _id

func set_amount(value:int):
	if _amount != value:
		_amount = value
		slot_changed.emit()

func get_amount() -> int:
	return _amount

func change(id:String, amount:int):
	_id = id
	_amount = amount
	slot_changed.emit()

func clear():
	## NOTE:持有当前 slot 的 inventory 会通过 slot_changed 信号自动将该对象清除
	if _amount != 0:
		set_amount(0)
	else:
		slot_changed.emit()
		 
	

#endregion
func can_exchange(other_slot:InventorySlot):
	if is_same_id(other_slot):
		return false
	return true

func exchange(other_slot:InventorySlot):
	var other_id = other_slot.get_id()
	var other_amount = other_slot.get_amount()
	other_slot.change(get_id(), get_amount())
	change(other_id, other_amount)

func can_stack(other_slot_ui:InventorySlot):
	if not is_same_id(other_slot_ui):
		return false
	return true

func stack_to(other_slot:InventorySlot):
	# self -> other_slot_ui
	other_slot.set_amount(other_slot.get_amount() + _amount)
	clear()





