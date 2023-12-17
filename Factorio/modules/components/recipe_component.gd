class_name RecipeComponent extends Node

signal recipe_changed

@export var recipe:Recipe:
	set(value):
		recipe = value
		recipe_changed.emit()

func consume(inputs:StorageCollection) -> bool:
	var recipe_storages = recipe.get_ingredients()
	var callables = []
	for recipe_storage:Storage in recipe_storages.get_storages():
		var input_storage = inputs.get_first_storage_by(recipe_storage.get_type())
		if not input_storage:
			return false
		var recipe_number = recipe_storage.get_number()
		if input_storage.get_number() < recipe_number:
			return false
		callables.append(func(): input_storage.take(recipe_number))
	for callable in callables:
		callable.call()	
	return true
