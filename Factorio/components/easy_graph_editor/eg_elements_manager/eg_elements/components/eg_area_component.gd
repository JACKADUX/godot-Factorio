class_name EGAreaComponent extends EGRect

signal mouse_entered
signal mouse_exited

var _mouse_inside := false 

func _unhandled_input(event):
	var inside = has_point(get_local_mouse_position())
	if not _mouse_inside and inside:
		_mouse_inside = inside
		mouse_entered.emit()
	elif _mouse_inside and not inside:
		_mouse_inside = inside
		mouse_exited.emit()
		
