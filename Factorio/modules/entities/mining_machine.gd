extends Node2D


var _inputs:StorageCollection
var _outputs:StorageCollection

@onready var fuel_component = %FuelComponent
@onready var craft_component = %CraftComponent
@onready var fuel_power_timer = %FuelPowerTimer
@onready var craft_timer = %CraftTimer


@onready var fuel_coal_storages := StorageCollection.create_from_strages([Storage.create(Enums.Items.Coal, 10)])
@onready var mine_coal_storages := StorageCollection.create_from_strages([Storage.create(Enums.Items.Coal, 100)])
 
func _ready():
	initialize.call_deferred()
	
func initialize():
	fuel_component.fuel_storages = fuel_coal_storages
	fuel_component.feed_fuel()
	
	var coal_recipe = [[Enums.Items.Coal, 1, 1], 1, [Enums.Items.Coal, 1, 1]]
	var recipe = Recipe.create_recipe_from(coal_recipe)
	craft_component.recipe = recipe
	craft_component.ingredients = mine_coal_storages
	craft_component.feed_ingredients()
	
func _process(delta):
	pass
	#if not fuel_power_timer.is_stopped():
		#$ProgressBar.value = (1-fuel_power_timer.get_percent())*100
		#if not craft_timer.is_stopped():
			#$ProgressBar2.value = craft_timer.get_percent()*100

#func _on_button_pressed():
	#fuel_coal_storage.feed(1)
	#fuel_component.feed_fuel()






