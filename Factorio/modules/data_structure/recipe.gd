class_name Recipe extends Resource

@export var _ingredients := StorageCollection.new()
@export var _outputs := StorageCollection.new()
@export var _crafting_time:float = 0.5  # s

func get_crafting_time():
	return _crafting_time

func get_empty_ingredients() -> StorageCollection:
	var sc = StorageCollection.clone(_ingredients)
	sc.set_all_storage_to_empty()
	return sc

func get_empty_outputs() -> StorageCollection:
	var sc = StorageCollection.clone(_outputs)
	sc.set_all_storage_to_empty()
	return sc

func consume(ingredients:StorageCollection) -> bool:
	var callables = []
	for recipe_storage:Storage in _ingredients.get_storages():
		var input_storage = ingredients.get_storage_by(recipe_storage.get_type())
		if not input_storage:
			return false
		var recipe_number = recipe_storage.get_number()
		if input_storage.get_number() < recipe_number:
			return false
		callables.append(func(): input_storage.take(recipe_number))
	for callable in callables:
		callable.call()
	return true

func collect(outputs:StorageCollection) -> bool:
	var callables = []
	for recipe_storage:Storage in _outputs.get_storages():
		var output_storage = outputs.get_storage_by(recipe_storage.get_type())
		if not output_storage:
			return false
		var recipe_number = recipe_storage.get_number()
		if output_storage.get_space_left() < recipe_number:
			return false
		callables.append(func(): output_storage.feed(recipe_number))
	for callable in callables:
		callable.call()
	return true

## Statics
static func create(consumes:StorageCollection, outputs:StorageCollection, time_cost:float=0) -> Recipe:
	var recipe = Recipe.new()
	recipe._ingredients = consumes
	recipe._outputs = outputs
	recipe._crafting_time = max(0.5, time_cost)
	return recipe
	
static func create_recipe_from(recipe_list:Array):
	"""
	# [type, consume/result, storage_max]
	var _formula_list = [
					[Items.Coal, 1, 1],  
					1, 
					[Items.Coal, 1, 1],
					]
	"""
	var ingredients = StorageCollection.new()
	var outputs = StorageCollection.new()
	var crafting_time = 0
	var input = true
	for info in recipe_list:
		if input:
			if typeof(info) in [TYPE_FLOAT, TYPE_INT]:
				crafting_time = info
				input = false
				continue
			var max_number = 100
			if info.size() == 3:
				max_number = info[2]
			ingredients.append_storage(Storage.create(info[0], info[1], max_number))
		else:
			var max_number = 100
			if info.size() == 3:
				max_number = info[2]
			outputs.append_storage(Storage.create(info[0], info[1], max_number))
	return Recipe.create(ingredients, outputs, crafting_time)

