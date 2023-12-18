class_name FuelPowerTimer extends StateTimer

# 1 MJ = 1,000,000 J
# 1 kW = 1,000 W
# 1 W = 1 J/s

@export var fuel_value:float = 4: # MJ
	set(value):
		fuel_value = value
		_update_wait_time()
		
@export var max_consumption:float = 150:  # kW
	set(value):
		max_consumption = value
		_update_wait_time()

func _ready():
	_update_wait_time()

func _update_wait_time():
	wait_time = fuel_value*1000/max_consumption


