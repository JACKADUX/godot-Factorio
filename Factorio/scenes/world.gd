extends Node2D

@onready var center_container_2 = $CanvasLayer/Control/CenterContainer2
@onready var grid = $Grid

@onready var main_tile_map = %MainTileMap
@onready var entity_manager = %EntityManager
@onready var building_tool = %BuildingTool

func _ready():
	building_tool.constructed.connect(_on_building_tool_constructed)
	building_tool.deconstructed.connect(_on_building_tool_deconstructed)
		
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_E:
				center_container_2.visible = not center_container_2.visible
			if event.keycode == KEY_G:
				grid.visible = not grid.visible

## 
func _get_tilemap_layer(layer_name:String):
	for layer:int in main_tile_map.get_layers_count():
		if main_tile_map.get_layer_name(layer) == layer_name:
			return layer

func _on_building_tool_constructed(building_grid_index:Vector2i):
	var player_inventory = Globals.player_inventory
	var slot = player_inventory.hand_slot
	var cdata = DatatableManager.get_construct_data(slot.item.id)
	var layer = _get_tilemap_layer(cdata.tilemap_layer_name)
	main_tile_map.set_cell(layer, building_grid_index, 0, cdata.atlas_coordinates, building_tool.get_rotation_tile())
	
	entity_manager.add_entity(entity_manager.new_entity(slot.item))
	print(get_tree().get_nodes_in_group(Globals.group_entity))

func _on_building_tool_deconstructed(building_grid_index:Vector2i):
	var layer = _get_tilemap_layer("Entity")
	main_tile_map.set_cell(1, building_grid_index, 0, Vector2i(-1,-1))
	entity_manager.remove_entity(get_tree().get_nodes_in_group(Globals.group_entity)[-1])
	
	
	
