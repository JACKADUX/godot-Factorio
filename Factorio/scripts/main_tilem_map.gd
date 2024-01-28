class_name MainTileMap extends TileMap

## NOTE: 留意调用的参数是 source_id 还是 layer_id
## NOTE: custom_data 只会返回对应 coords 的内容


var main_source:int = 0
var entity_layer:int
var tileset_atlas_source := tile_set.get_source(main_source) as TileSetAtlasSource


func _ready():
	entity_layer = get_tilemap_layer("Entity")
	
	## 从datatable_manager加载custom_data
	var data = DatatableManager.get_tilemap_data()
	
	
	## add collision and selection
	var collision_layer = 0
	var selection_layer = 1
	var tas = tileset_atlas_source
	for id in data:
		var item_data = data[id]
		var alternative_tile = 0
		## 覆盖原本的tile数据
		## WARNING: 原有的数据会被清除
		tas.remove_tile(item_data.atlas_coords)
		tas.create_tile(item_data.atlas_coords, item_data.size_in_atlas)
		#tas.move_tile_in_atlas()
		var tile_data = tas.get_tile_data(item_data.atlas_coords, alternative_tile)
		tile_data.texture_origin = item_data.texture_origin
		
		## 创建碰撞层 0
		tile_data.set_collision_polygons_count(collision_layer, 1)
		_create_custom_collision(tile_data, collision_layer, 0, item_data.size_in_atlas, item_data.collision_poly)
		## 创建选择层 1
		tile_data.set_collision_polygons_count(selection_layer, 1)
		_create_custom_collision(tile_data, selection_layer, 0, item_data.size_in_atlas, item_data.selection_poly)
		
		## add custom data
		tile_data.set_custom_data("id", id)
		
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		pass

## Interface
func get_entity_atlas_coords_from_rid(rid:RID):
	""" 通过碰撞rid直接获取当前碰撞所属的 tile 的 atlas_coords """
	var coords = get_coords_for_body_rid(rid)
	return get_cell_atlas_coords(entity_layer, coords)
	

func get_item_id_from(atlas_coords:Vector2i) -> String:
	var tile_data = tileset_atlas_source.get_tile_data(atlas_coords, 0)
	if tile_data:
		return tile_data.get_custom_data("id")
	return ""
		
func get_tilemap_layer(layer_name:String):
	for layer:int in get_layers_count():
		if get_layer_name(layer) == layer_name:
			return layer

## Utils
func _create_custom_collision(tile_data:TileData, c_layer:int, polygon_index:int, size_in_atlas:Vector2i, gaps:Array):
	tile_data.add_collision_polygon(c_layer)
	var rect = Rect2(Vector2.ZERO, size_in_atlas*Globals.GridSize)
	rect.position = -rect.size*0.5-Vector2(tile_data.texture_origin)
	rect = rect.grow_individual(-gaps[0], -gaps[1], -gaps[2], -gaps[3])
	var polygon := [rect.position, 
					rect.position + Vector2(0, rect.size.y),
					rect.position + rect.size,
					rect.position + Vector2(rect.size.x, 0)
					]
	tile_data.set_collision_polygon_points(c_layer, polygon_index, polygon)
	


	
