class_name EntityManager extends Node2D

const BASE_ENTITY = preload("res://modules/entity_manager/entities/base_entity.tscn")

func _ready():
	Globals.temp_entity_manager = self

func _feed_data():
	#var data = DatatableManager.get_construct_data("IRON_CHEST")
	pass

func new_entity(item:BaseItem):
	var entity = BASE_ENTITY.instantiate()
	entity.item = DatatableManager.base_items.IRON_CHEST
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
