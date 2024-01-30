extends InputHandler

@onready var main_camera = %MainCamera
@onready var main_tile_map = %MainTileMap
@onready var entity_manager = %EntityManager
@onready var user_interface = %UserInterface


@onready var _display_entity = %DisplayEntity
@onready var _tilemap_entity_detect_area = %TilemapEntityDetectArea
@onready var _detection_collision:= _tilemap_entity_detect_area.get_child(0)
@onready var _tilemap_cell_hovered_area = %TilemapCellHoveredArea
@onready var _selection_collision:= _tilemap_cell_hovered_area.get_child(0)
@onready var _selection_box = %SelectionBox


var current_cell_coords:Vector2i
var current_cell_position:Vector2

var building_cell_size:Vector2i
var building_cell_coords:Vector2i
var building_cell_position:Vector2
var building_direction_index: int = 0:
	get: return building_direction_index %4

var _detect_collision_count : int = 0
var _hover_entity_coords:Vector2i

func _ready():
	Globals.hand_slot.hand_slot_changed.connect(_on_hand_slot_changed.bind(Globals.hand_slot))
	mouse_state_changed.connect(_on_handle_input)
	wheel_scrolled.connect(_on_wheel_scrolled)
	
	_tilemap_entity_detect_area.body_shape_entered.connect(_on_entity_collision_shape_entered)
	_tilemap_entity_detect_area.body_shape_exited.connect(_on_entity_collision_shape_exited)
	_tilemap_cell_hovered_area.body_shape_entered.connect(_on_entity_selection_shape_entered)
	_tilemap_cell_hovered_area.body_shape_exited.connect(_on_entity_selection_shape_exited)
	_selection_collision.shape.size = Globals.GridSizeVector*0.8
	
	entity_manager.entity_constructed.connect(
		func(data): main_tile_map.construct_entity(data.id, data.coords, data.direction)
	)
	entity_manager.entity_deconstructed.connect(
		func(data):main_tile_map.deconstruct_entity(data.coords)	
	)

	
func _process(delta):
	_selection_collision.global_position = current_cell_position + Globals.GridSizeHalfVector
	_detection_collision.global_position = building_cell_position + building_cell_size*Globals.GridSizeHalf
	
	## display_entity
	var _dis_sqr = _display_entity.global_position.distance_squared_to(building_cell_position)
	if _dis_sqr > 2000:
		## NOTE: 解决鼠标起始位置过远时的延迟问题
		_display_entity.global_position = building_cell_position
	else:
		_display_entity.global_position = _display_entity.global_position.lerp(building_cell_position, 0.6)
	if _detect_collision_count != 0:
		_display_entity.modulate = Color(1,0,0, 0.6)
	else:
		_display_entity.modulate = Color(0,1,0, 0.6)
	
	
func _unhandled_input(event):
	handled_input(event)
	
func _on_handle_input():
	## NOTE: _unhandled_input
	_update_data()
	if is_just_pressed():
		if button_index == MOUSE_BUTTON_LEFT:
			var hand_slot = Globals.hand_slot
			if _detect_collision_count == 0 and not hand_slot.is_hand_empty():
				print("entity created")
				var player_inventory = Globals.player_inventory
				var entity = entity_manager.new_entity(hand_slot.get_item().id)
				if not entity:
					return 
				entity.coords = building_cell_coords
				entity.direction = building_direction_index
				entity_manager.add_entity(entity)	
				
			elif _hover_entity_coords:
				var entity :BaseEntity = entity_manager.get_entity_by_coords(_hover_entity_coords)
				if not entity:
					return 
				print("entity selected:", entity.get_item_id())
				var data = entity.get_entity_data()
				if data.has("inventory"):
					user_interface._show_chest(data.inventory)
				
		elif button_index == MOUSE_BUTTON_RIGHT:
			if _hover_entity_coords:
				print("entity deleted")
				var entity = entity_manager.get_entity_by_coords(building_cell_coords)
				if not entity:
					return 
				entity_manager.remove_entity(entity)
				
	if is_pressed_and_move():
		if button_index == MOUSE_BUTTON_MIDDLE:
			main_camera.set_world_offset(end_position -start_position)

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_R: # 旋转
			building_direction_index += 1 
		elif event.is_pressed() and event.keycode == KEY_Q: # 拿起/放回物品
			var hand_slot = Globals.hand_slot
			if hand_slot.is_hand_empty() and _hover_entity_coords:
				var item_id = main_tile_map.get_item_id_from(_hover_entity_coords)
				Globals.hand_slot.take_item_to_hand(Globals.player_inventory, DatatableManager.base_items[item_id])
			else:
				Globals.hand_slot.put_item_from_hand(Globals.player_inventory)
			

##
func _update_data():
	current_cell_coords = floor(current_position/Globals.GridSize)
	current_cell_position = current_cell_coords*Globals.GridSize
	if building_cell_size:
		building_cell_coords = main_tile_map.get_building_coords(current_position, building_cell_size)
		building_cell_position = building_cell_coords*Globals.GridSize

## OnSignals:

func _on_wheel_scrolled(value):
	_update_data()
	main_camera.wheel_scrolled(value)

func _on_hand_slot_changed(slot:HandSlot):
	_display_entity.hide()
	if slot.is_hand_empty():
		return 
	var item :BaseItem = slot.get_item()
	var tilemap_data = DatatableManager.get_tilemap_data_by(item.id)
	if not tilemap_data:
		return 
		
	_display_entity.show()
	_display_entity.texture = item.texture
	
	building_cell_size = tilemap_data.size 
	_detection_collision.shape.size = building_cell_size*Globals.GridSize*0.8
	_update_data()


# --------------------- Area2D
func _on_entity_collision_shape_entered(body_rid, tile_map:TileMap, body_shape_index, local_shape_index):
	if not tile_map is MainTileMap:
		return
	_detect_collision_count += 1
		
func _on_entity_collision_shape_exited(body_rid, tile_map:TileMap, body_shape_index, local_shape_index):
	if not tile_map is MainTileMap:
		return
	_detect_collision_count -= 1

func _on_entity_selection_shape_entered(body_rid, tile_map:TileMap, body_shape_index, local_shape_index):
	if not tile_map is MainTileMap:
		return
	_hover_entity_coords = tile_map.get_coords_for_body_rid(body_rid)
	_selection_box.show()
	_selection_box.global_position = _hover_entity_coords*Globals.GridSize
	var item_id = main_tile_map.get_item_id_from(_hover_entity_coords)
	var tilemap_data = DatatableManager.get_tilemap_data_by(item_id)
	_selection_box.size = tilemap_data.size*Globals.GridSize
	
func _on_entity_selection_shape_exited(body_rid, tile_map:TileMap, body_shape_index, local_shape_index):
	if not tile_map is MainTileMap:
		return
	#_hover_entity_coords = tile_map.get_coords_for_body_rid(body_rid)
	_selection_box.hide()
	_hover_entity_coords = Vector2i.ZERO




