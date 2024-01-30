class_name EntityManager extends Node2D

signal entity_constructed(data)
signal entity_deconstructed(data)


var entities :Array[BaseEntity] = []

func _ready():
	Globals.temp_entity_manager = self
	#_feed_data()
	
func _feed_data():
	add_entity(new_entity("IRON_CHEST"), Vector2(1,1))

func new_entity(item_id:String):
	var _entity :BaseEntity
	match item_id:
		"IRON_CHEST":
			_entity = EntityIronChest.new()
		
	if not _entity:
		push_error("_entity not exists. %s" % item_id)
		return 
	return _entity

func add_entity(value:BaseEntity, coords:Vector2):
	entities.append(value)
	value.coords = coords
	value.construct()
	entity_constructed.emit(value.get_entity_data())
	#value.entity_changed.connect(_on_entity_changed.bind(value))

func remove_entity(value:BaseEntity):
	#value.entity_changed.disconnect(_on_entity_changed.bind(value))
	value.deconstruct()
	entities.erase(value)
	entity_deconstructed.emit(value.get_entity_data())

func get_entity_by_coords(entity_coords:Vector2):
	for entity in entities:
		var coords = entity.coords
		if coords.is_equal_approx(entity_coords):
			return entity
			

func _process(delta):
	for entity in entities:
		entity.update(delta)
	
	
## OnSignals
