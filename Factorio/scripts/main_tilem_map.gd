class_name MainTileMap extends TileMap

## NOTE: 留意调用的参数是 source_id 还是 layer_id
## NOTE: custom_data 只会返回对应 coords 的内容


const Rotate0 = 0
const Rotate90 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_TRANSPOSE
const Rotate180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V
const Rotate270 = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_TRANSPOSE

const tile_rotations = [Rotate0, Rotate90, Rotate180, Rotate270]  # 返回 tilemap 的 set_cell 方法 alternative_tile: int 参数
const directions =[Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]


var entity_layer:int



func _ready():
	entity_layer = get_tilemap_layer("Entity")
	
	## 从datatable_manager加载custom_data
	var data = DatatableManager.get_tilemap_data()
	
	## add collision and selection
	var collision_layer = 0
	
	for id in data:
		var item_data = data[id]
		var alternative_tile = 0
		var tileset_atlas_source := tile_set.get_source(item_data.source_id) as TileSetAtlasSource 
		## 覆盖原本的tile数据
		## WARNING: 原有的数据会被清除
		tileset_atlas_source.remove_tile(item_data.atlas_coords)
		tileset_atlas_source.create_tile(item_data.atlas_coords, item_data.size_in_atlas)
		#tileset_atlas_source.move_tile_in_atlas()
		var tile_data = tileset_atlas_source.get_tile_data(item_data.atlas_coords, alternative_tile)
		tile_data.texture_origin = item_data.texture_origin
		
		## 创建碰撞层 0
		tile_data.set_collision_polygons_count(collision_layer, 1)
		_create_custom_collision(tile_data, collision_layer, 0, item_data.size_in_atlas, item_data.collision_poly)

		## add custom data
		tile_data.set_custom_data("id", id)
		
## Interface
func get_entity_atlas_coords_from_rid(rid:RID):
	""" 通过碰撞rid直接获取当前碰撞所属的 tile 的 atlas_coords """
	var coords = get_coords_for_body_rid(rid)
	return get_cell_atlas_coords(entity_layer, coords)


func get_tilemap_layer(layer_name:String):
	for layer:int in get_layers_count():
		if get_layer_name(layer) == layer_name:
			return layer


func construct_entity(item_id:String, coords:Vector2i, direction:int=0):
	var tilemap_data = DatatableManager.get_tilemap_data_by(item_id)
	var tile_rotate = 0 if not tilemap_data.rotatable else tile_rotations[direction]
	set_cell(entity_layer, coords, tilemap_data.source_id, tilemap_data.atlas_coords, tile_rotate)
	
func deconstruct_entity(item_id:String, coords:Vector2i):
	var tilemap_data = DatatableManager.get_tilemap_data_by(item_id)
	set_cell(entity_layer, coords, tilemap_data.source_id, Vector2i(-1,-1))

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
	


	
