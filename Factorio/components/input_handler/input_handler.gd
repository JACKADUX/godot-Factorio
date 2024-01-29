class_name InputHandler extends Node

signal wheel_scrolled(value)
signal mouse_state_changed

@export var drag_start_threshold_time :int = 200  # ms
@export var drag_start_threshold_distance :int = 4

var _dragged := false
var _hold_time :int = 0

enum MouseState {JUST_PRESSED, PRESSED_AND_MOVE, JUST_RELEASED, HOVERED}
var mouse_state:=MouseState.HOVERED:
	set(value):
		mouse_state = value
		mouse_state_changed.emit()
var button_index: MouseButton = MOUSE_BUTTON_NONE
var start_position:Vector2
var current_position:Vector2
var end_position:Vector2


## Interface
func handled_input(event:InputEvent):
	if not event is InputEventMouse:
		return 
	current_position = _get_global_mouse_position_from(event)
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			wheel_scrolled.emit(1)
		elif event.is_pressed() and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			wheel_scrolled.emit(-1)
			
		elif event.is_pressed():
			if button_index == MOUSE_BUTTON_NONE:
				_start_drag(current_position)
				button_index = event.button_index
				mouse_state = MouseState.JUST_PRESSED
		elif not event.is_pressed():
			if button_index == event.button_index:
				mouse_state = MouseState.JUST_RELEASED
				button_index = MOUSE_BUTTON_NONE
				_end_drag(current_position)
				
	elif event is InputEventMouseMotion:
		if button_index == _conver_mask_to_index(event.button_mask):
			_check_drag(current_position)
			mouse_state = MouseState.PRESSED_AND_MOVE
		else:
			mouse_state = MouseState.HOVERED

func is_dragged() -> bool:
	return _dragged

func is_just_pressed():
	return mouse_state == MouseState.JUST_PRESSED

func is_pressed_and_move():
	return mouse_state == MouseState.PRESSED_AND_MOVE

func is_just_released():
	return mouse_state == MouseState.JUST_RELEASED

func is_hovered():
	return mouse_state == MouseState.HOVERED

## Utils
func _get_global_mouse_position_from(event:InputEventMouse):
	var view_to_world = get_viewport().get_canvas_transform().affine_inverse()
	var world_position = view_to_world * event.position
	return world_position
	
func _conver_mask_to_index(mask):
	match mask:
		MOUSE_BUTTON_MASK_LEFT: return MOUSE_BUTTON_LEFT
		MOUSE_BUTTON_MASK_RIGHT: return MOUSE_BUTTON_RIGHT
		MOUSE_BUTTON_MASK_MIDDLE: return MOUSE_BUTTON_MIDDLE

func _start_drag(start_position:Vector2):
	self.start_position = start_position
	self.end_position = start_position
	_dragged = false
	_hold_time = Time.get_ticks_msec()
	
func _end_drag(end_position:Vector2):
	self.end_position = end_position
			
func _check_drag(end_position:Vector2) -> bool:
	self.end_position = end_position
	if _dragged:
		return true
	var dt = Time.get_ticks_msec()-_hold_time
	var dd = (self.end_position-start_position).length_squared()
	if dt > drag_start_threshold_time or dd > drag_start_threshold_distance*drag_start_threshold_distance:
		_dragged = true
		return true
	return false



	
