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
	var e = new_entity("IRON_CHEST")
	e.coords = Vector2i(5,5)
	e.inventory.input(Items.COAL, 100)
	add_entity(e)
	
	e = new_entity("INSERTER_1")
	e.coords = Vector2i(6,5)
	add_entity(e)
	
	e = new_entity("IRON_CHEST")
	e.coords = Vector2i(7,5)
	e.inventory.input(Items.IRON_ORE, 100)
	add_entity(e)


func _process(delta):
	_work_notification.emit(delta)
		
## Interface
func get_entities():
	return entities
		
func new_entity(item_id:String):
	var _entity :BaseEntity
	match item_id:
		"IRON_CHEST":
			_entity = EntityIronChest.new()
		"INSERTER_1":
			_entity = EntityInserter1.new()
		
	if not _entity:
		push_error("_entity not exists. %s" % item_id)
		return 
	_entity.size = DatatableManager.get_tilemap_data_by(item_id).size
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
		
func get_entity_by_coords(entity_coords:Vector2i):
	for entity in get_entities():
		var coords = entity.coords
		if coords == entity_coords:
			return entity

