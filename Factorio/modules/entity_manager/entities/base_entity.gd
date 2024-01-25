class_name BaseEntity extends Node2D

signal entity_changed

var item:BaseItem

func _enter_tree():
	add_to_group(Globals.group_entity)

func _exit_tree():
	remove_from_group(Globals.group_entity)

func construct():
	pass

func deconstruct():
	pass
