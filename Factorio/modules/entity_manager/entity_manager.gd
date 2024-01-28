class_name EntityManager extends Node2D

const IRON_CHEST = preload("res://scenes/entities/iron_chest.tscn")

func _ready():
	Globals.temp_entity_manager = self

func _feed_data():
	#var data = DatatableManager.get_construct_data("IRON_CHEST")
	pass

func new_entity(item:BaseItem):
	var ENTITY_PACKED_SCENE:PackedScene
	match item.id:
		"IRON_CHEST":
			ENTITY_PACKED_SCENE = IRON_CHEST
	if not ENTITY_PACKED_SCENE:
		push_error("ENTITY_PACKED_SCENE not exists. %s" % item.id)
		return 
	
	var entity = ENTITY_PACKED_SCENE.instantiate()
	return entity

func add_entity(value:BaseEntity):
	add_child(value)
	value.construct()
	value.entity_changed.connect(_on_entity_changed.bind(value))

func remove_entity(value:BaseEntity):
	value.entity_changed.disconnect(_on_entity_changed.bind(value))
	value.deconstruct()
	remove_child(value)
	value.queue_free()

## OnSignals
func _on_entity_changed(value:BaseEntity):
	print(value)
