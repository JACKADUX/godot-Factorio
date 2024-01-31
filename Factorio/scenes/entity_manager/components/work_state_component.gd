class_name WorkStateComponent extends EntityBaseComponent

signal work_state_changed

enum WorkState {Idle, Start, Busy, End}
var work_state := WorkState.Idle:
	set(value):
		if work_state != value:
			work_state = value
			work_state_changed.emit()

func is_idle_state():
	return work_state == WorkState.Idle
func is_start_state():
	return work_state == WorkState.Start
func is_busy_state():
	return work_state == WorkState.Busy
func is_end_state():
	return work_state == WorkState.End
	
func to_idle_state():
	work_state = WorkState.Idle
func to_start_state():
	work_state = WorkState.Start
func to_busy_state():
	work_state = WorkState.Busy
func to_end_state():
	work_state = WorkState.End

