class_name ImageAreaComponent extends Node2D

signal mouse_entered
signal mouse_exited

@export var image_region_component:ImageRegionComponent
@export var disable:= false:
	set(value):
		disable = value
		if is_inside_tree():
			set_process(not disable)

var _area := Rect2()

var _is_inside := false

## Virtual
func _ready():
	image_region_component.region_changed.connect(_on_region_changed)
	disable = disable
	_on_region_changed()
	
func _process(delta):
	check_area()
	
## Interface
func is_mouse_inside():
	return _is_inside

func has_alpha_at(global_point:Vector2):
	var image = image_region_component.get_image()
	if not image:
		return false
	var local_point = image_region_component.get_global_transform().affine_inverse() * global_point
	if not _area.has_point(local_point):
		return false
	return image.get_pixelv(local_point).a > 0

func is_inside_area_at(global_point:Vector2):
	if not _area.has_area():
		return false
	var local_point = image_region_component.get_global_transform().affine_inverse() * global_point
	return _area.has_point(local_point)

func get_area():
	return _area



## Utils
func check_area():
	var is_inside_region = is_inside_area_at(get_global_mouse_position())
	if not _is_inside and is_inside_region:
		_is_inside = true
		mouse_entered.emit()
	elif _is_inside and not is_inside_region:
		mouse_exited.emit()
		_is_inside = false

## OnSignal
func _on_region_changed():
	_area = image_region_component.get_region()
	
