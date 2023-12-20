class_name ImageRegionComponent extends Node

signal region_changed

@export var sprite:Sprite2D

enum RegionType {Full, Used}
@export var region_type:RegionType = RegionType.Full:
	set(value):
		region_type = value
		if is_inside_tree():
			_region = get_region()
			region_changed.emit()

var _region := Rect2()

## Virtual
func _ready():
	sprite.texture_changed.connect(_on_texture_changed)
	_on_texture_changed()

## Interface
func get_region():
	return _region
	
func get_global_transform():
	if sprite:
		return sprite.global_transform
		
## Utils
func get_image():
	if sprite.texture:
		return sprite.texture.get_image()

func update_region():
	if region_type == RegionType.Full:
		_region = sprite.get_rect()
	else:
		_region = get_image_used_region()

func get_image_used_region():
	var image = get_image()
	if not image:
		return Rect2()
	return image.get_used_rect()

func _on_texture_changed():
	update_region()
	region_changed.emit()













