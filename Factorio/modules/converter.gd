class_name Converter extends RefCounted

signal formula_changed

var _formula :Formula

var _start_state:=false

func is_started():
	return _start_state
	
func set_formula(formula:Formula):
	_formula = formula
	formula_changed.emit()
	
func consume_inputs(inputs:StorageCollection) -> bool:
	if _start_state:
		#push_error("already started")
		return false
	if _formula.consume_inputs(inputs):
		_start_state = true
		return true
	return false
	
func get_time_cost():
	return _formula.get_time_cost()

func collect_outputs(outputs:StorageCollection) -> bool:
	if not _start_state:
		#push_error("not started")
		return false
	if _formula.collect_outputs(outputs):
		_start_state = false
		return true
	return false
				


































