class_name EGCamera extends Camera2D

signal view_changed
signal world_offset_changed
signal view_zoom_changed

@export var scale_factor :float = 1.2
@export var ZOOM_MAX :float= 30.0
@export var ZOOM_MIN :float= 0.1

@onready var _view_rect :Rect2 = new_view_rect()


## Virtual
func _ready():
	get_viewport().size_changed.connect(check_camera_view_changed)

## Interface
func set_world_offset(value:Vector2):
	""" 将摄像机视图中的世界坐标向 Value 方向偏移"""
	if value.is_zero_approx():
		return 
	global_position -= value
	world_offset_changed.emit()
	check_camera_view_changed()

func zoom_in():
	if zoom.x < ZOOM_MIN:
		return 
	set_zoom_offset(get_global_mouse_position(), 1)
	view_zoom_changed.emit()
	check_camera_view_changed()

func zoom_out():
	if zoom.x > ZOOM_MAX:
		return 
	set_zoom_offset(get_global_mouse_position(), -1)
	view_zoom_changed.emit()
	check_camera_view_changed()
	
func get_view_rect():
	return _view_rect
	
## Utils
func set_zoom_offset(point:Vector2, direction:int) -> void:
	var _factor = scale_factor if direction < 0 else 1/scale_factor
	zoom *= _factor
	point -= get_center_pos()
	global_position += point*(_factor-1)
	
func check_camera_view_changed():
	var new_view_rect = new_view_rect()
	if _view_rect != new_view_rect:
		_view_rect = new_view_rect
		view_changed.emit()

func new_view_rect() -> Rect2:
	var _view_rect = get_viewport_rect()
	_view_rect.size /= zoom
	_view_rect.position = get_center_pos() -_view_rect.size*0.5
	return _view_rect

func get_center_pos() -> Vector2:
	#get_screen_center_position() 刷新会有问题
	return global_position+offset

