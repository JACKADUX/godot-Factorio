class_name Recipe extends Resource

@export var _ingredients := StorageCollection.new()
@export var _output := StorageCollection.new()
@export var _crafting_time:float = 0.5  # s

func get_crafting_time():
	return _crafting_time

func get_ingredients() -> StorageCollection:
	return _ingredients
	
## Statics
static func create(consumes:StorageCollection, output:StorageCollection, time_cost:float=0) -> Recipe:
	var recipe = Recipe.new()
	recipe._ingredients = consumes
	recipe._output = output
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
	var output = StorageCollection.new()		
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
			output.append_storage(Storage.create(info[0], info[1], max_number))
	return Recipe.create(ingredients, output, crafting_time)

