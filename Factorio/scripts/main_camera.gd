extends Camera2D

signal view_changed
signal world_offset_changed
signal view_zoom_changed

@export var scale_factor :float = 1.2
@export var ZOOM_MAX :float= 30.0
@export var ZOOM_MIN :float= 0.1

@onready var _view_rect :Rect2 = _new_view_rect()

## Virtual
func _enter_tree():
	Globals.main_camera = self

func _ready():
	get_viewport().size_changed.connect(_check_camera_view_changed)

## Interface
func wheel_scrolled(value):
	if Input.is_key_pressed(KEY_CTRL):
		if value > 0:
			set_world_offset(Vector2(0, -100))
		else:
			set_world_offset(Vector2(0, 100))
		
	elif Input.is_key_pressed(KEY_SHIFT):
		if value > 0:
			set_world_offset(Vector2(-100, 0))
		else:
			set_world_offset(Vector2(100, 0))
	else:
		if value > 0:
			zoom_in()
		else:
			zoom_out()

func set_world_offset(value:Vector2):
	""" 将摄像机视图中的世界坐标向 Value 方向偏移"""
	if value.is_zero_approx():
		return 
	global_position -= value
	world_offset_changed.emit()
	_check_camera_view_changed()

func zoom_in():
	if zoom.x < ZOOM_MIN:
		return 
	_set_zoom_offset(get_global_mouse_position(), 1)
	view_zoom_changed.emit()
	_check_camera_view_changed()

func zoom_out():
	if zoom.x > ZOOM_MAX:
		return 
	_set_zoom_offset(get_global_mouse_position(), -1)
	view_zoom_changed.emit()
	_check_camera_view_changed()
	
func get_view_rect():
	return _view_rect
	
## Utils
func _set_zoom_offset(point:Vector2, direction:int) -> void:
	var _factor = scale_factor if direction < 0 else 1/scale_factor
	zoom *= _factor
	point -= _get_center_pos()
	global_position += point*(_factor-1)
	
func _check_camera_view_changed():
	var _new_view_rect = _new_view_rect()
	if _view_rect != _new_view_rect:
		_view_rect = _new_view_rect
		view_changed.emit()

func _new_view_rect() -> Rect2:
	var _view_rect = get_viewport_rect()
	_view_rect.size /= zoom
	_view_rect.position = _get_center_pos() -_view_rect.size*0.5
	return _view_rect

func _get_center_pos() -> Vector2:
	#get_screen_center_position() 刷新会有问题
	return global_position+offset


