extends Node2D

@export var image_region_component:ImageRegionComponent
@export var outline_color := Color.DIM_GRAY:
	set(value):
		outline_color = value
		if is_inside_tree():
			queue_redraw()
@export var outline_width := 2.0:
	set(value):
		outline_width = value
		if is_inside_tree():
			queue_redraw()

@onready var points :PackedVector2Array

## Virtual
func _ready():
	image_region_component.region_changed.connect(queue_redraw)
	var cam = get_viewport().get_camera_2d()
	if cam.has_signal("view_changed"):
		cam.view_changed.connect(queue_redraw)	
	

func _draw():
	if not is_inside_tree():
		return 
	global_transform = image_region_component.sprite.global_transform
	var rect = image_region_component.get_region()
	draw_rect(rect, outline_color, false, outline_width/get_viewport().get_camera_2d().zoom.x)

	
	
	
	
	
	
