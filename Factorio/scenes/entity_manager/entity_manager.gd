class_name EntityManager extends Node2D

signal entity_constructed(data)
signal entity_deconstructed(data)

enum EntityNotification {NewEntityConsturct}


var logistics :Array[BaseEntity] = []
var productions :Array[BaseEntity] = []

func _ready():
	Globals.temp_entity_manager = self

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
	for entity in logistics:
		entity.update(delta)
	for entity in productions:
		entity.update(delta)
		
## Interface
func get_entities():
	return [] + logistics + productions

func is_entity_logistics(entity:BaseEntity):
	return get_entity_type(entity) == DatatableManager.item_type.LOGISTICS

func is_entity_productions(entity:BaseEntity):
	return get_entity_type(entity) == DatatableManager.item_type.PRODUCTIONS
	
func get_entity_type(entity:BaseEntity):
	var item_id = entity.get_item_id()
	return DatatableManager.item_datas[item_id].type
	
func get_entity_type_list(entity:BaseEntity):
	var list :Array
	if is_entity_logistics(entity):
		list = logistics
	elif is_entity_productions(entity):
		list = productions
	return list
	
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
	var type_list = get_entity_type_list(value)
	type_list.append(value)
	value.construct()
	_entity_notification(EntityNotification.NewEntityConsturct)
	entity_constructed.emit(value.get_entity_data())

func remove_entity(value:BaseEntity):
	value.deconstruct()
	var type_list = get_entity_type_list(value)
	type_list.erase(value)
	value._entity_manager = null
	entity_deconstructed.emit(value.get_entity_data())

func get_entity_by_coords(entity_coords:Vector2i):
	for entity in get_entities():
		var coords = entity.coords
		if coords == entity_coords:
			return entity
			
## Utils
func _entity_notification(what:EntityNotification, msg:={}):
	match what:
		EntityNotification.NewEntityConsturct:
			## 只有 logistics 才会在意是否有新对象加入
			for entity in logistics:
				entity._entity_notification(what)
	
	
## OnSignals
