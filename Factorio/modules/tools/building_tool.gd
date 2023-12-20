class_name BuildingTool extends EGBaseTool

@onready var building_tool_area = $BuildingToolArea

var grid_index:Vector2i
var grid_position:Vector2

var building_gird_size:Vector2i = Vector2i(2,2)
var building_grid_index:Vector2i
var building_grid_position:Vector2

func _ready():
	building_tool_area.set_rect(Rect2(Vector2.ZERO, building_gird_size*Globals.GridSize))

func handle_mouse_input(mih:MouseInputHandler):
	grid_index = floor(mih.current_position/Globals.GridSize)
	grid_position = grid_index*Globals.GridSize
	building_grid_index = get_building_index(mih.current_position)
	building_grid_position = building_grid_index*Globals.GridSize
	building_tool_area.global_position = building_grid_position
	super(mih)


func get_building_index(position:Vector2) -> Vector2:
	var index = grid_index-building_gird_size/2
	if building_gird_size.x % 2 == 0:
		if position.x > (grid_index.x+ 0.5)*Globals.GridSize:
			index.x = grid_index.x -(building_gird_size.x/2-1)
	if building_gird_size.y % 2 == 0:
		if position.y > (grid_index.y+ 0.5)*Globals.GridSize :
			index.y = grid_index.y -(building_gird_size.y/2-1)
	return index
	
	
