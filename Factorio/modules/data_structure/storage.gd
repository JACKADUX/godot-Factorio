class_name Storage extends Resource

signal storage_changed

@export var _type:int = 0
@export var _number:int = 0
@export var _max_number:int = 100

static func create(type:int, number:int, max_number:int=100) -> Storage:
	var storage = Storage.new() 
	storage._type = type
	storage._number = number
	storage._max_number = max_number
	return storage

#region Interface
func is_same_type(other:Storage):
	return _type == other.get_type()

func get_type():
	return _type

func set_number(value:int):
	assert(value>=0)
	_number = value
	storage_changed.emit()

func get_number():
	return _number

func get_max_number():
	return _max_number

func is_full():
	return _number >= _max_number

func is_empty():
	return _number <= 0

func get_space_left():
	return max(_max_number -_number, 0)

func request_take(value:int) -> int:
	assert(value>=0)
	if value == 0:
		return 0
	if value > _number:
		value = _number
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

func request_feed(value:int) -> int:
	assert(value>=0)
	var space_left = _max_number -_number
	if value > space_left:
		value = space_left
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

static func clone(storage:Storage) -> Storage:
	return Storage.create(storage.get_type(), storage.get_number(), storage.get_max_number())

