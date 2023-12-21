class_name BuildingTool extends EGBaseTool

@onready var building_tool_area := $BuildingToolArea as Node2D

@onready var half_grid = Globals.GridSizeV*0.5 

var mouse_grid_index:Vector2i
var mouse_grid_position:Vector2

@export var building_gird_size:Vector2i = Vector2i(1,1)
var building_grid_index:Vector2i
var building_grid_position:Vector2

func _ready():
	building_tool_area.set_rect(Rect2(Vector2.ZERO, building_gird_size*Globals.GridSize))

func handle_mouse_input(mih:MouseInputHandler):
	mouse_grid_index = floor(mih.current_position/Globals.GridSize)
	mouse_grid_position = mouse_grid_index*Globals.GridSize
	building_grid_index = get_building_index(mih.current_position)
	building_grid_position = building_grid_index*Globals.GridSize
	building_tool_area.global_position = building_grid_position
	super(mih)


func get_building_index(position:Vector2) -> Vector2:
	var index = mouse_grid_index-building_gird_size/2
	if building_gird_size.x % 2 == 0:
		if position.x > (mouse_grid_index.x+ 0.5)*Globals.GridSize:
			index.x = mouse_grid_index.x -(building_gird_size.x/2-1)
	if building_gird_size.y % 2 == 0:
		if position.y > (mouse_grid_index.y+ 0.5)*Globals.GridSize :
			index.y = mouse_grid_index.y -(building_gird_size.y/2-1)
	return index
	
	
