class_name StateTimer extends Timer

signal state_changed

func _enter_tree():
	timeout.connect(turn_off)
	one_shot = true
	
## Interface
func turn_on():
	start()
	state_changed.emit()

func turn_off():
	stop()
	state_changed.emit()

func get_percent():
	return (1-time_left/wait_time)
