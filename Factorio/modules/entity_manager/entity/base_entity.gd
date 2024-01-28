class_name BaseEntity extends Node2D

signal entity_changed
@export var _item_id :String = "" 
var item:BaseItem:
	get:
		if not item:
			item = DatatableManager.base_items[_item_id]
		return item

func _enter_tree():
	add_to_group(Globals.group_entity)

func _exit_tree():
	remove_from_group(Globals.group_entity)

func _ready():
	pass

func construct():
	pass

func deconstruct():
	pass
