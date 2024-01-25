class_name PowerConnector extends Node

@export var fuel_power_timer :FuelPowerTimer

func _ready():
	var parent = get_parent()
	assert(parent is StateTimer, "Parent must be a StateTimer")
	fuel_power_timer.state_changed.connect(func(): parent.paused = fuel_power_timer.is_stopped())
