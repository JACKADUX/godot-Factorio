extends Node2D


var _inputs:StorageCollection
var _outputs:StorageCollection

@onready var recipe_component = %RecipeComponent
@onready var power_component = %PowerComponent
@onready var craft_component = %CraftComponent

@onready var fuel_coal_storage := Storage.create(Enums.Items.Coal, 1)
@onready var mine_coal_storages := StorageCollection.create_from_strages([Storage.create(Enums.Items.Coal, 1000)])
 
func _ready():
	var coal_recipe = [[Enums.Items.Coal, 1, 1], 1, [Enums.Items.Coal, 1, 1]]
	var recipe = Recipe.create_recipe_from(coal_recipe)
	recipe_component.recipe = recipe
	power_component.state_changed.connect(feed_fuel)
	power_component.state_changed.connect(func():
		craft_component.paused = power_component.is_stopped()
		)
	craft_component.state_changed.connect(feed_ingredients)
	
	initialize()
	
func initialize():
	feed_fuel()
	feed_ingredients()
	
func _process(delta):
	if not power_component.is_stopped():
		$ProgressBar.value = (1-power_component.get_percent())*100
		if not craft_component.is_stopped():
			$ProgressBar2.value = craft_component.get_percent()*100

	
func feed_fuel():
	if not power_component.is_stopped():
		return 
	if not fuel_coal_storage.request_take(1):
		print("not enough fuel")
		return 
	fuel_coal_storage.take(1)
	power_component.fuel_value = 1
	power_component.max_consumption = 150
	power_component.turn_on()
	print("power_component fuel left: ", fuel_coal_storage.get_number())
	
func feed_ingredients():
	if not craft_component.is_stopped():
		return 
	craft_component.crafting_speed = 0.25
	craft_component.crafting_time = recipe_component.recipe.get_crafting_time()
	if recipe_component.consume(mine_coal_storages):
		craft_component.turn_on()
		print("craft_component: ", mine_coal_storages.get_type_total_data())
	else:
		print("not enough inputs")
			

func _on_button_pressed():
	fuel_coal_storage.feed(1)
	feed_fuel()






