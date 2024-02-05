extends InputHandler

@onready var main_camera = %MainCamera
@onready var main_tile_map = %MainTileMap
@onready var entity_manager = %EntityManager
@onready var user_interface = %UserInterface


@onready var _display_entity = %DisplayEntity
@onready var _selection_box = %SelectionBox

@onready var entity_information_panle = %EntityInformationPanle

var current_cell_coords:Vector2i

var hovered_entity:BaseEntity
var construct_entity_size:Vector2i
var construct_entity_coords:Vector2i
var _constructable := false

var building_direction_index: int = 0:
	get: return building_direction_index %4

var _curruent_item_rotatable := false



func _ready():
	Globals.hand_inventory.inventory_changed.connect(_on_hand_inventory_changed.bind(Globals.hand_inventory))
	mouse_state_changed.connect(_on_handle_input)
	wheel_scrolled.connect(_on_wheel_scrolled)
	
	entity_manager.entity_constructed.connect(
		func(data): main_tile_map.construct_entity(data.id, data.coords, data.direction)
	)
	entity_manager.entity_deconstructed.connect(
		func(data):main_tile_map.deconstruct_entity(data.id, data.coords)	
	)


func _unhandled_input(event):
	handled_input(event)
	
func _on_handle_input():
	## NOTE: _unhandled_input
	if is_pressed_and_move():
		if button_index == MOUSE_BUTTON_MIDDLE:
			main_camera.set_world_offset(end_position -start_position)
	
	_update_data()
	_check_construct_entity()
	
	if is_just_pressed():
		if button_index == MOUSE_BUTTON_LEFT:
			if hovered_entity:
				print("entity selected:", hovered_entity.get_item_id())
				var data = hovered_entity.get_entity_data()
				if data.has("inventory"):
					user_interface._show_chest(data.inventory)
					return 
			var hand_slot = Globals.hand_inventory.get_slot(0)
			if _constructable and hand_slot :
				var id = hand_slot.get_id()
				if not DatatableManager.is_item_constructable(id):
					return
				var player_inventory = Globals.player_inventory
				var entity = entity_manager.new_entity(id)
				if not entity:
					return 
				entity.coords = construct_entity_coords
				entity.direction = building_direction_index
				entity_manager.add_entity(entity)	
				print("entity created")
				

		elif button_index == MOUSE_BUTTON_RIGHT:
			if hovered_entity:
				entity_manager.remove_entity(hovered_entity)
				print("entity deleted")
				
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_R: # 旋转
			if _curruent_item_rotatable:
				building_direction_index += 1 
				_display_entity.rotation_degrees = building_direction_index*90
			
		elif event.is_pressed() and event.keycode == KEY_Q: # 拿起/放回物品
			var hand_slot = Globals.hand_inventory.get_slot(0)
			if not hand_slot and hovered_entity:
				Inventory.transfer(Globals.player_inventory, hovered_entity.get_item_id(), -1, Globals.hand_inventory)
			elif hand_slot:
				Inventory.transfer(Globals.hand_inventory, hand_slot.get_id(), -1, Globals.player_inventory)
			
##
func _update_data():
	var new_coords = Vector2i(floor(current_position/Globals.GridSize))
	if new_coords == current_cell_coords:
		return 
	current_cell_coords = new_coords
	_check_hovered_entity()
	
	
## OnSignals:
func _on_wheel_scrolled(value):
	main_camera.wheel_scrolled(value)
	_update_data()

func _on_hand_inventory_changed(inventory:Inventory):
	construct_entity_size = Vector2.ZERO
	_display_entity.hide()
	var slots = inventory.get_valid_slots()
	if not slots:
		return 
	var item_id :String = slots[0].get_id()
	var tilemap_data = DatatableManager.get_tilemap_data_by(item_id)
	if not tilemap_data:
		return 
	_curruent_item_rotatable = tilemap_data.rotatable
	if not _curruent_item_rotatable:
		_display_entity.rotation_degrees = 0
	else:
		_display_entity.rotation_degrees = building_direction_index*90
	_display_entity.show()
	_display_entity.texture = DatatableManager.item_datas[item_id].texture
	
	construct_entity_size = tilemap_data.size 
	_update_data()


func _check_hovered_entity():
	var entity = entity_manager.get_entity_by_coords(current_cell_coords)
	if entity == hovered_entity:
		return 
	hovered_entity = entity
	if not entity:
		_selection_box.hide()
		entity_information_panle.update(null)
		return
	_selection_box.show()
	_selection_box.size = hovered_entity.size*Globals.GridSize
	_selection_box.global_position = hovered_entity.coords*Globals.GridSize
	## debug
	entity_information_panle.update(entity)
	
func _check_construct_entity():
	construct_entity_coords = entity_manager.get_construct_coords(current_position, construct_entity_size)
	_display_entity.global_position = construct_entity_coords*Globals.GridSize
	_constructable = not entity_manager.has_intersect_entities(Rect2i(construct_entity_coords, construct_entity_size))
	if not _constructable:
		_display_entity.modulate = Color(1,0,0, 0.6)
	else:
		_display_entity.modulate = Color(0,1,0, 0.6)



