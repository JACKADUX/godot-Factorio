class_name Storage extends RefCounted

signal storage_changed

var _type_fixed := false
var _type:int = 0
var _number:int = 0
var _max_number:int = 64

#region Interface
func set_type_fixed(value:bool):
	_type_fixed = value

func is_type_fixed():
	return _type_fixed

func is_same_type(other:Storage):
	return _type == other.get_type()

func set_type(type:int):
	_type = type
		
func get_type():
	return _type

func set_number(value:int):
	assert(value>=0)
	_number = value
	storage_changed.emit()

func get_number():
	return _number

func is_full():
	return _number >= _max_number

func is_empty():
	return _number <= 0

func request_feed(value:int) -> int:
	assert(value>=0)
	var space_left = _max_number -_number
	if value > space_left:
		value = space_left
	return value
	
func take(value:int) -> int:
	assert(value>=0)
	if value == 0:
		return 0
	if value > _number:
		value = _number
	_number -= value
	storage_changed.emit()
	return value
	
func feed(value:int):
	assert(value>=0)
	if value == 0:
		return
	if _number + value <= _max_number:
		_number += value
		storage_changed.emit()
	else:
		push_error("feed _number larger than spaceleft")

#endregion
