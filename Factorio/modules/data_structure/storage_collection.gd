class_name StorageCollection extends Resource

@export var _storages :Array[Storage] = []
	
func get_storages():
	return _storages

func append_storage(value:Storage):
	if value not in _storages:
		_storages.append(value)

func remove_storage(value:Storage):
	if value in _storages:
		_storages.erase(value)

func clear():
	_storages = [] 

func remove_empty_storage():
	var new_storage = []
	for storage in _storages:
		if storage.is_empty():
			continue
		new_storage.append(storage)
	_storages = new_storage

func size():
	return _storages.size()
	
func is_empty():
	return not _storages

func set_all_storage_to_empty():
	for storage:Storage in _storages:
		storage.set_number(0)
		
func is_all_storage_empty() -> bool:
	for storage:Storage in _storages:
		if storage.get_number() != 0:
			return false
	return true

func get_type_total_data() -> Dictionary:
	var data := {}
	for storage:Storage in _storages:
		var type = storage.get_type()
		var number = storage.get_number()
		var space_left = storage.get_space_left()
		if not data.has(type):
			data[type] = {"number":0, "space_left":0, "storage_list":[]}
		data[type].number += number
		data[type].space_left += space_left
		data[type].storage_list.append(storage)
	return data

func collect_storages_by(storage_type:int) -> StorageCollection:
	var data = get_type_total_data()
	if data.has(storage_type):
		return create_from_strages(data[storage_type].storage_list)
	return null

func get_first_storage_by(storage_type:int) -> Storage:
	var data = get_type_total_data()
	if data.has(storage_type):
		return data[storage_type].storage_list[0]
	return null
	
## Statics
static func create_from_strages(storages:Array) -> StorageCollection:
	var sc = StorageCollection.new()
	for storage in storages:
		if storage is Storage:
			sc.append_storage(storage)
	return sc




























