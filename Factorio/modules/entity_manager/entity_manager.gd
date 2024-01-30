class_name EntityManager extends Node2D

signal entity_constructed(data)
signal entity_deconstructed(data)

enum EntityNotification {NewConsturct}

var entities :Array[BaseEntity] = []

func _ready():
	Globals.temp_entity_manager = self
	#_feed_data()

func _feed_data():
	var Items = DatatableManager.base_items
	var e = new_entity("IRON_CHEST")
	e.coords = Vector2i(5,5)
	e.inventory.add_item(Items.COAL, 100)
	add_entity(e)
	
	e = new_entity("INSERTER_1")
	e.coords = Vector2i(6,5)
	add_entity(e)
	
	e = new_entity("IRON_CHEST")
	e.coords = Vector2i(7,5)
	e.inventory.add_item(Items.IRON_ORE, 100)
	add_entity(e)


func _process(delta):
	for entity in entities:
		entity.update(delta)
		
## Interface
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
	return _entity

func add_entity(value:BaseEntity):
	value._entity_manager = self
	entities.append(value)
	value.construct()
	_entity_notification(EntityNotification.NewConsturct)
	entity_constructed.emit(value.get_entity_data())
	#value.entity_changed.connect(_on_entity_changed.bind(value))

func remove_entity(value:BaseEntity):
	#value.entity_changed.disconnect(_on_entity_changed.bind(value))
	value.deconstruct()
	entities.erase(value)
	value._entity_manager = null
	entity_deconstructed.emit(value.get_entity_data())

func get_entity_by_coords(entity_coords:Vector2i):
	for entity in entities:
		var coords = entity.coords
		if coords == entity_coords:
			return entity
			
## Utils
func _entity_notification(what:EntityNotification):
	for entity in entities:
		entity._entity_notification(what)
	
	
## OnSignals
