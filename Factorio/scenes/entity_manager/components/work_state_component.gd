class_name WorkStateComponent extends EntityBaseComponent

signal work_state_changed

enum WorkState {Idel, Start, Busy, End}
var work_state := WorkState.Idel:
	set(value):
		if work_state != value:
			work_state = value
			work_state_changed.emit()

func is_idel_state():
	return work_state == WorkState.Idel
func is_start_state():
	return work_state == WorkState.Start
func is_busy_state():
	return work_state == WorkState.Busy
func is_end_state():
	return work_state == WorkState.End
	
func to_idel_state():
	work_state = WorkState.Idel
func to_start_state():
	work_state = WorkState.Start
func to_busy_state():
	work_state = WorkState.Busy
func to_end_state():
	work_state = WorkState.End

