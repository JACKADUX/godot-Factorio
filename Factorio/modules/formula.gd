class_name Formula extends RefCounted

var _inputs:Array[Storage] = []
var _outputs:Array[Storage] = []
var _time_cost:float = 0

func get_time_sost():
	return _time_cost

func get_outputs():
	return _outputs

func apply_formula(storages:Array[Storage]):
	var storage_list = []
	for input:Storage in _inputs:
		for storage:Storage in storages:
			if not storage.is_same_type(input):
				continue
			if storage.get_number() < input.get_number():
				continue
			storage_list.append(storage)
			break
	if storage_list.size() != _inputs.size():
		return false
	for i in storage_list.size():
		storage_list[i].take(_inputs[i].get_number())
		
	return true
