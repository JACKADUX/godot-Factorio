class_name Enums extends Node

enum Items {Null, 
			Coal,
			IronOre,
			CopperOre, 
			
	}


				

static func create_formula_from(formula_list:Array):
	"""
	[type, consume/result, storage_max]
	var _formula_list = [
					[Items.Coal, 1, 1],  
					0.5, 
					[Items.Coal, 1, 1],
					]
	"""
	var consumes = StorageCollection.new()
	var results = StorageCollection.new()		
	var time_cost = 0
	var input = true
	for info in formula_list:
		if input:
			if typeof(info) in [TYPE_FLOAT, TYPE_INT]:
				time_cost = info
				input = false
				continue
			var max_number = 64
			if info.size() == 3:
				max_number = info[2]
			consumes.append_storage(Storage.create(info[0], info[1], max_number))
		else:
			var max_number = 64
			if info.size() == 3:
				max_number = info[2]
			results.append_storage(Storage.create(info[0], info[1], max_number))
	return Formula.create(consumes, results, time_cost)
	
static func formula_coal_mine():
	var formula_list = [
		[Items.Coal, 1, 1],  
		2, 
		[Items.Coal, 1, 1],
	]
	return create_formula_from(formula_list)
