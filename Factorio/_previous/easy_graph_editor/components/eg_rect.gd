class_name EGRect extends Node2D

signal rect_changed

@export var rect:Rect2
@export var fill:= false
@export var fill_color:= Color.ALICE_BLUE
@export var outline:= false
@export var outline_color := Color.ALICE_BLUE
@export var outline_width :float = 2.0

var _eg_camera:Camera2D

func _draw():
	if not _eg_camera:
		_eg_camera = get_viewport().get_camera_2d()
		if _eg_camera is EGCamera:
			_eg_camera.view_changed.connect(queue_redraw)	
	if fill:
		draw_rect(rect, fill_color, true)
	if outline:
		var zoom = outline_width/_eg_camera.zoom.x if _eg_camera else 1
		draw_rect(rect, outline_color, false, zoom)

func set_rect(rect:Rect2):
	self.rect = rect
	queue_redraw()
	rect_changed.emit()

func has_point(value:Vector2):
	return rect.has_point(value)


