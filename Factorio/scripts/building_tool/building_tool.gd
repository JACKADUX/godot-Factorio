class_name BuildingTool extends Node2D

signal constructed(grid_index:Vector2i)
signal deconstructed(grid_index:Vector2i)
signal entity_clicked(entity_coords)

@onready var display_entity = %DisplayEntity
@onready var entity_detect_area = %EntityDetectArea
@onready var mouse_selection_area = %MouseSelectionArea

var _selection_collision:CollisionShape2D
var _detection_collision:CollisionShape2D

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

#### entity
var _collide_atlas_coords:= []
var _hover_entity_coords :Vector2i
var _hover_entity_atlas_coords :Vector2i
var _hover_entity_item_id :String

func _ready():
	var player_inventory = Globals.player_inventory
	player_inventory.hand_slot_changed.connect(_on_hand_slot_changed.bind(player_inventory.hand_slot))
	InputHandler.mouse_state_changed.connect(_handle_input)
	
	entity_detect_area.body_shape_entered.connect(_on_entity_collision_shape_entered)
	entity_detect_area.body_shape_exited.connect(_on_entity_collision_shape_exited)
	
	_detection_collision = entity_detect_area.get_child(0)
	
	mouse_selection_area.body_shape_entered.connect(_on_entity_selection_shape_entered)
	mouse_selection_area.body_shape_exited.connect(_on_entity_selection_shape_exited)
	
	_selection_collision = mouse_selection_area.get_child(0)
	_selection_collision.shape.size = Globals.GridSizeVector*0.8
	hide()

func _process(delta):
	_update_grid_index()
	_selection_collision.global_position = current_grid_position + Globals.GridSizeHalfVector
	_detection_collision.global_position = building_grid_position + building_grid_size*Globals.GridSizeHalf
	display_entity.global_position = display_entity.global_position.lerp(building_grid_position, 0.6)
	
	if not _collide_atlas_coords.is_empty():
		display_entity.modulate = Color(1,0,0, 0.6)
	else:
		display_entity.modulate = Color(0,1,0, 0.6)

			
func _handle_input():
	if InputHandler.is_just_pressed():
		if InputHandler.button_index == MOUSE_BUTTON_LEFT:
			if _collide_atlas_coords.is_empty():
				constructed.emit(building_grid_index)
			elif _hover_entity_coords:
				entity_clicked.emit(_hover_entity_coords)
				
		elif InputHandler.button_index == MOUSE_BUTTON_RIGHT:
			if _hover_entity_coords:
				_collide_atlas_coords.erase(_hover_entity_atlas_coords)
				deconstructed.emit(_hover_entity_coords)
			
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_R: # 旋转
			direction_index = (direction_index+1) %4
		elif event.is_pressed() and event.keycode == KEY_Q: # 拿起/放回物品
			var hand_slot = Globals.player_inventory.hand_slot
			if hand_slot.is_null() and _hover_entity_item_id:
				Globals.player_inventory.hold_item(DatatableManager.base_items[_hover_entity_item_id])
			else:
				Globals.player_inventory.put_down_hand_item()
			
## Interface
func get_rotation_tile():
	# 返回 tilemap 的 set_cell 方法 alternative_tile: int 参数
	return _tile_rotations[direction_index]

## Utils
func _update_grid_index():
	var gmp = get_global_mouse_position()
	current_grid_index = floor(gmp/Globals.GridSize)
	current_grid_position = current_grid_index*Globals.GridSize
	building_grid_index = _get_building_index(current_grid_index, gmp, building_grid_size)
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


## OnSignals
func _on_hand_slot_changed(slot:InventorySlot):
	if slot.is_null():
		hide()
	else:
		var item = slot.item
		var cdata = DatatableManager.get_tilemap_data_by(item.id)
		if not cdata:
			hide()
			return 
		building_grid_size = cdata.size 
		display_entity.texture = item.texture
		_detection_collision.shape.size = building_grid_size*Globals.GridSize*0.8
		show()

func _on_entity_collision_shape_entered(body_rid, main_tile_map:TileMap, body_shape_index, local_shape_index):
	if not main_tile_map is MainTileMap:
		return
	_collide_atlas_coords.append(main_tile_map.get_entity_atlas_coords_from_rid(body_rid))
		
func _on_entity_collision_shape_exited(body_rid, main_tile_map:TileMap, body_shape_index, local_shape_index):
	if not main_tile_map is MainTileMap:
		return
	_collide_atlas_coords.erase(main_tile_map.get_entity_atlas_coords_from_rid(body_rid))


func _on_entity_selection_shape_entered(body_rid, main_tile_map:TileMap, body_shape_index, local_shape_index):
	if not main_tile_map is MainTileMap:
		return
	_hover_entity_coords = main_tile_map.get_coords_for_body_rid(body_rid)
	_hover_entity_atlas_coords = main_tile_map.get_entity_atlas_coords_from_rid(body_rid)
	_hover_entity_item_id = main_tile_map.get_item_id_from(_hover_entity_atlas_coords)
		
func _on_entity_selection_shape_exited(body_rid, main_tile_map:TileMap, body_shape_index, local_shape_index):
	if not main_tile_map is MainTileMap:
		return
	_hover_entity_coords = main_tile_map.get_coords_for_body_rid(body_rid)
	_hover_entity_atlas_coords = main_tile_map.get_entity_atlas_coords_from_rid(body_rid)
	_hover_entity_item_id = main_tile_map.get_item_id_from(_hover_entity_atlas_coords)





