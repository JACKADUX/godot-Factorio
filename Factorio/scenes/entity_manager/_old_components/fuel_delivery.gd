class_name FuelComponent extends Node

signal fuel_changed

@export var fuel_power_timer:FuelPowerTimer
@export var fuel_storages:StorageCollection:
	set(value):
		fuel_storages = value
		fuel_changed.emit()

func _ready():
	fuel_power_timer.state_changed.connect(feed_fuel)

func feed_fuel():
	if not fuel_storages or not fuel_power_timer.is_stopped():
		return 
	var fuel_storage = fuel_storages.get_storage_by(Enums.Items.Coal)
	if not fuel_storage:
		return 
	if not fuel_storage.request_take(1):
		print("not enough fuel")
		return 
	fuel_storage.take(1)
	fuel_power_timer.turn_on()

