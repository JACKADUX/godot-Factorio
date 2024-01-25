class_name CraftTimer extends StateTimer


@export var crafting_speed:float = 1: #/s
	set(value):
		crafting_speed = value
		_update_wait_time()
@export var crafting_time:float = 1: #s 
	set(value):
		crafting_time = value
		_update_wait_time()

func _ready():
	_update_wait_time()

func _update_wait_time():
	wait_time = crafting_time/crafting_speed

	

