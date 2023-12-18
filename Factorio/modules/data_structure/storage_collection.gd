class_name StorageCollection extends Resource

signal storages_changed

@export var _storages :Array[Storage] = []


func get_storages():
	return _storages

func set_storages_changed():
	storages_changed.emit()

func append_storage(value:Storage):
	if value not in _storages:
		_storages.append(value)
		value.storage_changed.connect(set_storages_changed)
		storages_changed.emit()

func remove_storage(value:Storage):
	if value in _storages:
		_storages.erase(value)
		value.storage_changed.disconnect(set_storages_changed)
		storages_changed.emit()

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

func get_storage_by(storage_type:int) -> Storage:
	for storage in _storages:
		if storage.get_type() == storage_type:
			return storage
	return null
	
## Statics
static func create_from_strages(storages:Array) -> StorageCollection:
	var sc = StorageCollection.new()
	for storage in storages:
		if storage is Storage:
			sc.append_storage(storage)
	return sc

static func clone(storages:StorageCollection) -> StorageCollection:
	var new_storages = StorageCollection.new()
	for storage:Storage in storages.get_storages():
		new_storages.append_storage(Storage.clone(storage))
	return new_storages


























