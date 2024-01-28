extends Node2D

@onready var center_container_2 = $CanvasLayer/Control/CenterContainer2
@onready var grid = $Grid

@onready var main_tile_map = %MainTileMap
@onready var entity_manager = %EntityManager
@onready var building_tool = %BuildingTool

func _ready():
	building_tool.constructed.connect(_on_building_tool_constructed)
	building_tool.deconstructed.connect(_on_building_tool_deconstructed)
	building_tool.entity_clicked.connect(_on_entity_clicked)
		
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_E:
				center_container_2.visible = not center_container_2.visible
			if event.keycode == KEY_G:
				grid.visible = not grid.visible

## 

func _on_building_tool_constructed(building_grid_index:Vector2i):
	var player_inventory = Globals.player_inventory
	var slot = player_inventory.hand_slot
	var cdata = DatatableManager.get_tilemap_data_by(slot.item.id)
	var layer = main_tile_map.get_tilemap_layer("Entity")
	main_tile_map.set_cell(layer, building_grid_index, 0, cdata.atlas_coords, building_tool.get_rotation_tile())
	
	var entity = entity_manager.new_entity(slot.item.id)
	if not entity:
		return 
	entity_manager.add_entity(entity, building_tool.building_grid_index)

	
	#print(get_tree().get_nodes_in_group(Globals.group_entity))

func _on_building_tool_deconstructed(building_grid_index:Vector2i):
	var layer = main_tile_map.get_tilemap_layer("Entity")
	main_tile_map.set_cell(1, building_grid_index, 0, Vector2i(-1,-1))
	#entity_manager.remove_entity(get_tree().get_nodes_in_group(Globals.group_entity)[-1])

func _on_entity_clicked(entity_coords):
	var entity = entity_manager.get_entity_by_coords(entity_coords)
	print(entity)
	
	
