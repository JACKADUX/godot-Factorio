class_name Storage extends RefCounted

signal storage_changed

var _type:int = 0
var _number:int = 0
var _max_number:int = 64

func get_type():
	if _number == 0:
		_type = 0
	return _type

func get_number():
	return _number

func is_full():
	return _number >= _max_number

func is_empty():
	return _number <= 0

func request_feed(type:int, num:int) -> int:
	assert(type!=0)
	assert(num>=0)
	if _number == 0:
		_type = type
	elif _type != type:
		return 0
	var space_left = _max_number -_number
	if num > space_left:
		num = space_left
	return num
	
func take(num:int) -> int:
	assert(num>=0)
	if num == 0:
		return 0
	if num > _number:
		num = _number
	_number -= num
	storage_changed.emit()
	return num
	
func feed(num:int):
	assert(num>=0)
	if num == 0:
		return
	if _number +num <= _max_number:
		_number += num
		storage_changed.emit()
	else:
		push_error("feed _number larger than spaceleft")
