class_name EGGrid extends Node2D

@export var eg_camera :EGCamera

@export var small_grid := Vector2(32, 32)
@export var larg_grid := Vector2(128, 128)

## Virtual
func _ready():
	eg_camera.view_changed.connect(queue_redraw)
	
func _draw():
	var area_rect = eg_camera.get_view_rect()
	var zoom = eg_camera.zoom.x
	if zoom>0.5:
		draw_grid(area_rect, small_grid, Color(0.2,0.2,0.2), 2/zoom)
	draw_grid(area_rect, larg_grid, Color(0.3,0.3,0.3), 2/zoom)
		
## Utils
func draw_grid(area_rect:Rect2, gap_size=Vector2(128, 128), color:=Color.DIM_GRAY, width:float=2):
	var offset = Vector2(floor(area_rect.position.x / gap_size.x) *int(gap_size.x)-area_rect.position.x, 
						 floor(area_rect.position.y / gap_size.y) *int(gap_size.y)-area_rect.position.y)
	var points = creat_grid_multiline(area_rect, gap_size, offset)
	if points:
		draw_multiline(points, color, width)

## Static
static func creat_grid_multiline(area_rect:Rect2, gap_size=Vector2(128, 128), offset:=Vector2.ZERO) -> PackedVector2Array:
	var grid_multiline = []
	var start_position = area_rect.position + offset
	while true:
		var should_x_continue = start_position.x <= area_rect.end.x 
		var should_y_continue = start_position.y <= area_rect.end.y 
		if should_x_continue:
			if area_rect.position.x <= start_position.x:
				grid_multiline.append(Vector2(start_position.x, area_rect.position.y))
				grid_multiline.append(Vector2(start_position.x, area_rect.end.y))
			start_position.x += gap_size.x
		if should_y_continue:
			if area_rect.position.y <= start_position.y:
				grid_multiline.append(Vector2(area_rect.position.x, start_position.y))
				grid_multiline.append(Vector2(area_rect.end.x, start_position.y))
			start_position.y += gap_size.y
		if not should_x_continue and not should_y_continue:
			break
	return grid_multiline
	

