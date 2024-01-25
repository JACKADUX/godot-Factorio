class_name CraftComponent extends Node

signal recipe_changed
signal ingredients_changed

@export var craft_timer:CraftTimer
@export var recipe:Recipe:
	set(value):
		recipe = value
		recipe_changed.emit()
@export var ingredients:StorageCollection:
	set(value):
		ingredients = value
		ingredients_changed.emit()
@export var outputs:StorageCollection

var _consumed := false

func _ready():
	craft_timer.state_changed.connect(feed_ingredients)
	recipe_changed.connect(_on_recipe_changed)
	
func feed_ingredients():
	if not craft_timer or not recipe or not ingredients:
		return 
	if not craft_timer.is_stopped():
		return 
	
	if _consumed:
		if not recipe.collect(outputs):
			print("not enough output space to collect")
			return 
		_consumed = false
		print("outputs: ", outputs.get_type_total_data())
	if recipe.consume(ingredients):
		craft_timer.turn_on()
		_consumed = true
		print("craft_timer: ", ingredients.get_type_total_data())
	else:
		print("not enough inputs")
		

func _on_recipe_changed():
	if recipe:
		craft_timer.crafting_time = recipe.get_crafting_time()
		ingredients = recipe.get_empty_ingredients()
		outputs = recipe.get_empty_outputs()
		
