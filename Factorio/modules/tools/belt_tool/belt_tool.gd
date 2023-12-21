class_name BeltTool extends BuildingTool

@onready var debug_draw = $DebugDraw
@onready var tile_map = $TileMap


const Rotate0 = 0
const Rotate90 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_TRANSPOSE
const Rotate180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V
const Rotate270 = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_TRANSPOSE

var tile_rotations = [Rotate0, Rotate90, Rotate180, Rotate270]
var direction_index = 0  # 0 90 180 270
var directions =[Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
var direction = directions[direction_index]
var linelist = []
var start_grid 

func _ready():
	super()
	debug_draw.draw.connect(_on_draw)

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_R:
			direction_index = (direction_index+1) %4
			direction = directions[direction_index]
			debug_draw.queue_redraw()

func just_pressed(mih:MouseInputHandler):
	if mih.button_index == MOUSE_BUTTON_LEFT:
		start_grid = mouse_grid_position+half_grid
		add_belt()
	if mih.button_index == MOUSE_BUTTON_RIGHT:
		remove_belt()
		
func pressed_and_move(mih:MouseInputHandler):
	if mih.button_index == MOUSE_BUTTON_LEFT:
		add_belt()
	if mih.button_index == MOUSE_BUTTON_RIGHT:
		remove_belt()
		
func just_released(mih:MouseInputHandler):
	pass
	
func hovered(mih:MouseInputHandler):
	debug_draw.queue_redraw()



func add_belt():
	var pos = mouse_grid_position+half_grid
	if direction.x == 0:
		pos.x = start_grid.x
	if direction.y == 0:
		pos.y = start_grid.y
	if pos in linelist:
		return 
	linelist.append([pos, direction])
	debug_draw.queue_redraw()
	
	#tile_map.set_cell(0, Vector2i(floor(pos/Globals.GridSize))-direction, 0, Vector2i(0,2), tile_rotations[direction_index])
	tile_map.set_cell(0, floor(pos/Globals.GridSize), 0, Vector2i(0,0), tile_rotations[direction_index])
	#tile_map.set_cell(0, Vector2i(floor(pos/Globals.GridSize))+direction, 0, Vector2i(0,3), tile_rotations[direction_index])

func remove_belt():
	linelist = []
	var pos = mouse_grid_position+half_grid
	tile_map.set_cell(-1, floor(pos/Globals.GridSize), -1)
	debug_draw.queue_redraw()
	
func _draw_arrow(pos, dir:Vector2):
	var to = pos+dir*half_grid
	debug_draw.draw_line(pos-dir*half_grid, to, Color.AZURE, 1, true)
	debug_draw.draw_line(to, to-dir.rotated(deg_to_rad(45))*half_grid*0.5, Color.AZURE, 1, true)
	debug_draw.draw_line(to, to-dir.rotated(deg_to_rad(-45))*half_grid*0.5, Color.AZURE, 1, true)

func _on_draw():
	#for p in linelist:
	#	_draw_arrow(p[0], p[1])
	_draw_arrow(mouse_grid_position+half_grid, direction)
			
			
			
			
			
			
			
			
			
			
