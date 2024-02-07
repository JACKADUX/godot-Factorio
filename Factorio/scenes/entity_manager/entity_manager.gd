class_name EntityManager extends Node2D

signal entity_constructed(data)
signal entity_deconstructed(data)

signal _work_notification(delta:float)
signal _inner_consturct_notification(entity:BaseEntity)
signal _inner_deconsturct_notification(entity:BaseEntity)

enum EntityNotification {NewEntityConsturct}


var entities :Array[BaseEntity] = []

func _ready():
	Globals.temp_entity_manager = self

func _feed_data():
	var Items = DatatableManager.base_items
	var e = new_entity(Items.IRON_CHEST)
	e.coords = Vector2i(5,5)
	e.inventory.input(Items.COAL, 100)
	add_entity(e)
	
	e = new_entity(Items.INSERTER_1)
	e.coords = Vector2i(6,5)
	add_entity(e)
	
	e = new_entity(Items.IRON_CHEST)
	e.coords = Vector2i(7,5)
	e.inventory.input(Items.IRON_ORE, 100)
	add_entity(e)
	
	e = new_entity(Items.MINING_DRILL)
	e.coords = Vector2i(9,5)
	add_entity(e)
	
	e = new_entity(Items.TRANSPORT_BELT_1)
	e.coords = Vector2i(9,3)
	add_entity(e)


func _process(delta):
	_work_notification.emit(delta)
		
## Interface
func get_entities():
	return entities
		
func new_entity(id:int):
	var _entity :BaseEntity
	var Items = DatatableManager.base_items
	match id:
		Items.IRON_CHEST:
			_entity = EntityIronChest.new(id)
		Items.INSERTER_1:
			_entity = EntityInserter1.new(id)
		Items.MINING_DRILL:
			_entity = EntityMiningDrill.new(id)
		Items.TRANSPORT_BELT_1:
			_entity = EntityTransportBelt1.new(id)
		
	if not _entity:
		push_error("_entity not exists. %s" % id)
		return 
	_entity.size = DatatableManager.get_tilemap_data_by(id).size
	return _entity

func add_entity(value:BaseEntity):
	entities.append(value)
	value.construct(self)
	entity_constructed.emit(value.get_entity_data())
	_inner_consturct_notification.emit(value)
	if value.is_worker:
		_work_notification.connect(
			value._entity_notification.bind(BaseEntity.NotificationType.Work)
		)
	if value.construct_notification:
		_inner_consturct_notification.connect(
			value._entity_notification.bind(BaseEntity.NotificationType.Construct)
			)
	if value.deconstruct_notification:
		_inner_deconsturct_notification.connect(
			value._entity_notification.bind(BaseEntity.NotificationType.Deconstruct)
			)
		
func remove_entity(value:BaseEntity):
	value.deconstruct()
	entities.erase(value)
	_inner_deconsturct_notification.emit(value)
	entity_deconstructed.emit(value.get_entity_data())
	if value.is_worker:
		_work_notification.disconnect(
			value._entity_notification.bind(BaseEntity.NotificationType.Work)
		)
	if value.construct_notification:
		_inner_consturct_notification.disconnect(
			value._entity_notification.bind(BaseEntity.NotificationType.Construct)
			)
	if value.deconstruct_notification:
		_inner_deconsturct_notification.disconnect(
			value._entity_notification.bind(BaseEntity.NotificationType.Deconstruct)
			)
		
func get_entity_by_coords(coords:Vector2i):
	for entity in get_entities():
		if coords == entity.coords:
			return entity
		if Rect2i(entity.coords, entity.size).has_point(coords):
			return entity

func get_construct_coords(_position:Vector2, entity_size:Vector2i ) -> Vector2:
	""" 根据传入的鼠标位置和建筑尺寸(ixj) 返回应该建造的cell coords (左上角)"""
	var cell_index = Vector2i(floor(_position/Globals.GridSize))
	var coords = cell_index-entity_size/2
	if entity_size.x % 2 == 0:
		if _position.x > (cell_index.x+ 0.5)*Globals.GridSize:
			coords.x = cell_index.x -(entity_size.x/2-1)
	if entity_size.y % 2 == 0:
		if _position.y > (cell_index.y+ 0.5)*Globals.GridSize :
			coords.y = cell_index.y -(entity_size.y/2-1)
	return coords

func has_intersect_entities(rect:Rect2i)-> bool:
	for entity in get_entities():
		if Rect2i(entity.coords, entity.size).intersects(rect):
			return true
	return false

func get_intersect_entities(rect:Rect2i):
	var entities := []
	for entity in get_entities():
		if Rect2i(entity.coords, entity.size).intersects(rect):
			entities.append(entities)























