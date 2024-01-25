class_name TransformComponent extends Node

signal transform_changed

@export var object:Node2D 

var _transform : Transform2D

func start_trans():
	_transform = object.global_transform

func end_trans():
	if object.global_transform != _transform:
		_transform = object.global_transform 
		transform_changed.emit()

func get_start_trans():
	return _transform

func get_start_position():
	return _transform.origin
