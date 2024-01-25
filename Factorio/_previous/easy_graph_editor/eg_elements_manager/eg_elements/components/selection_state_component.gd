class_name SelectStateComponent extends Node

signal select_state_changed

@export var selectable := true:
	set(value):
		if is_inside_tree():
			if is_selected():
				deselect()
		selectable = value

@export var state:=false:
	set(value):
		state = value
		if value:	
			select()
		else:
			deselect()
	get:
		return is_selected()
		
var _state := false

func is_selected():
	return _state

func select():
	if not selectable:
		return 
	_state = true
	select_state_changed.emit()

func deselect():
	if not selectable:
		return
	_state = false
	select_state_changed.emit()
	
