class_name Formula extends RefCounted

var _consumes := StorageCollection.new()
var _results := StorageCollection.new()
var _time_cost:float = 0

static func create(consumes:StorageCollection, results:StorageCollection, time_cost:float=0) -> Formula:
	var form = Formula.new()
	form._consumes = consumes
	form._results = results
	form._time_cost = max(0, time_cost)
	return form
	
func get_time_cost():
	return _time_cost

func get_results():
	return _results.duplicate(true)

func consume_inputs(inputs:StorageCollection):
	var consume_total_data = _consumes.get_type_total_data()
	var input_total_data = inputs.get_type_total_data()
	var callable_list = []
	for consume_type in consume_total_data:
		if consume_type == 0:
			continue
		if not input_total_data.has(consume_type):
			return false
		var consume_data = consume_total_data[consume_type]
		var input_data = input_total_data[consume_type]
		if consume_data.number > input_data.number:
			return false
		callable_list.append(func():
			var consume_number = consume_data.number
			for storage:Storage in input_data.storage_list:
				consume_number -= storage.take(consume_number)
		)
	for callable in callable_list:
		callable.call()
	return true

func collect_outputs(outputs:StorageCollection):
	"""
	注意： outputs 内部必须包含 _results 中的所有type 否则返回false
	"""
	var result_total_data = _results.get_type_total_data()
	var output_total_data = outputs.get_type_total_data()
	var callable_list = []
	
	for result_type in result_total_data:
		if result_type == 0:
			continue
		if not output_total_data.has(result_type):
			return false
		var result_data = result_total_data[result_type]
		var output_data = output_total_data[result_type]
		if output_data.space_left < result_data.number:
			return false
		
		callable_list.append(func():
			var result_number = result_data.number
			for storage:Storage in output_data.storage_list:
				var request = storage.request_feed(result_number)
				storage.feed(request)
				result_number -= request
		)
	for callable in callable_list:
		callable.call()
		
	return true

























