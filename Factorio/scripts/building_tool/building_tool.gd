extends Node2D

@onready var debug = $"../CanvasLayer/Control/Debug"
@onready var display_box = $"../DisplayBox"


@export var main_tile_map:TileMap

const Rotate0 = 0
const Rotate90 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_TRANSPOSE
const Rotate180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V
const Rotate270 = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_TRANSPOSE

const _tile_rotations = [Rotate0, Rotate90, Rotate180, Rotate270]
const _directions =[Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
var direction_index = 0  # 0 90 180 270
var direction: Vector2i:
	get: return _directions[direction_index]

#### Grid Index
var current_grid_index:Vector2i
var current_grid_position:Vector2

var building_grid_size:Vector2i = Vector2i(2,2)
var building_grid_index:Vector2i
var building_grid_position:Vector2

func _ready():
	InputHandler.mouse_state_changed.connect(_on_mouse_state_changed)

func _process(delta):
	global_position = global_position.lerp(building_grid_position, 0.8)
	
	debug.text = str(current_grid_index)
	
func _on_mouse_state_changed():
	_update_grid_index()
	var atlas_coords = Vector2i(0,3)
	if InputHandler.is_just_pressed():
		if InputHandler.button_index == MOUSE_BUTTON_LEFT:
			_add_entity(building_grid_index, atlas_coords)
		elif InputHandler.button_index == MOUSE_BUTTON_RIGHT:
			_remove_entity(building_grid_index)

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_R:
			direction_index = (direction_index+1) %4

## Utils
func _add_entity(coords:Vector2i, atlas_coords: Vector2i):
	#layer: int, coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0
	main_tile_map.set_cell(1, coords, 0, atlas_coords, _tile_rotations[direction_index])

func _remove_entity(coords:Vector2i):
	main_tile_map.set_cell(1, coords, 0, Vector2i(-1,-1))
	
	

func _update_grid_index():
	current_grid_index = floor(InputHandler.current_position/Globals.GridSize)
	current_grid_position = current_grid_index*Globals.GridSize
	building_grid_index = _get_building_index(current_grid_index, InputHandler.current_position, building_grid_size)
	building_grid_position = building_grid_index*Globals.GridSize

func _get_building_index(_grid_index:Vector2i, _position:Vector2, _size:Vector2i ) -> Vector2:
	""" 根据传入的鼠标位置和建筑尺寸(ixj) 返回应该建造的grid index (左上角)"""
	var index = _grid_index-_size/2
	if _size.x % 2 == 0:
		if _position.x > (_grid_index.x+ 0.5)*Globals.GridSize:
			index.x = _grid_index.x -(_size.x/2-1)
	if _size.y % 2 == 0:
		if _position.y > (_grid_index.y+ 0.5)*Globals.GridSize :
			index.y = _grid_index.y -(_size.y/2-1)
	return index


func _on_area_2d_body_shape_entered(body_rid, body:TileMap, body_shape_index, local_shape_index):
	if not body is TileMap:
		return
	const EntityLayer = 1
	
	var tileset_atlas_source = body.tile_set.get_source(0)
	
	
	var collidedTiles = body.get_used_cells(EntityLayer)
	var coords = body.get_coords_for_body_rid(body_rid)
	var atlas_coords = body.get_cell_atlas_coords(EntityLayer, coords)
	var tdata = body.get_cell_tile_data(EntityLayer, coords)
	
	var size_in_atlas = tileset_atlas_source.get_tile_size_in_atlas(atlas_coords)

	display_box.size = size_in_atlas*Globals.GridSize
	display_box.global_position = coords*Globals.GridSize













