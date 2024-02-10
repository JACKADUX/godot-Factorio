class_name EntityManager extends Node2D

signal entity_constructed(data)
signal entity_deconstructed(data)

signal _work_notification(delta:float)
signal _inner_consturct_notification(entity:BaseEntity)
signal _inner_deconsturct_notification(entity:BaseEntity)

enum EntityNotification {NewEntityConsturct}


var entities :Array[BaseEntity] = []

var belts = []

var _t:float = 0

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
	
	var input_belt
	var first
	for i in 10:
		e = new_entity(Items.TRANSPORT_BELT_1)
		e.coords = Vector2i(2+i,3)
		if i == 0:
			first = e
		#if randf()>0.5:
			e._belt_1.push_front(Items.COAL)
		add_entity(e)
		e.input_transport_belt = input_belt
		input_belt = e
		belts.append(e)
	#first.input_transport_belt = e

	
func _process(delta):
	_work_notification.emit(delta)
	queue_redraw()
	
	## _debug
	_t += delta
	if _t >= 1 :
		_t = 0
		if randf() > 0.2:
			belts[0]._belt_1.push_front([DatatableManager.base_items.COAL, DatatableManager.base_items.IRON_ORE].pick_random())
		if randf() > 0.5:
			belts[-1]._belt_1.pop_end()
		 
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


func _draw():
	for entity in get_entities():
		if entity.get_item_id() ==  DatatableManager.base_items.TRANSPORT_BELT_1:
			var bits = entity._belt_1._bits
			if not bits:
				continue
			var inds = entity._belt_1._get_indexs()
			for i in inds:
				var c = Color.AQUA
				if entity._belt_1._slots[inds.find(i)] == DatatableManager.base_items.COAL:
					c = Color(0.2,0.2,0.2)
				var offset = Vector2i(8*i, 0)
				draw_circle(entity.coords*Globals.GridSize+Vector2i(0, Globals.GridSizeHalf)+offset, 4, c)





















