class_name EGElementsManager extends Node2D

signal selection_changed

@export var eg_camera:EGCamera

@onready var collection := $EGElementCollection as EGElementCollection

## Virtual
func _ready():
	pass
	#for i in 100:
	#	new_element()
	for element in collection.get_elements():
		element.select_state_component.select_state_changed.connect(_on_selection_changed)
		
## Interface
func get_selectable_elements() -> Array:
	var elments:= []
	for elment: EGBaseElement in collection.get_elements_in_mouse_inside_group():
		if not elment.select_state_component.selectable:
			continue
		elments.append(elment)
	return elments

func get_selectable_element():
	var elements = get_selectable_elements()
	if elements:
		return elements[-1]

func get_selected_elements()-> Array: 
	var selects = []
	for item in collection.get_elements():
		if item.select_state_component.is_selected():
			selects.append(item)
	return selects

func select(element:EGBaseElement):
	element.select_state_component.select()
	
func deselect(element:EGBaseElement):
	element.select_state_component.deselect()

func is_selected(element:EGBaseElement) -> bool:
	return element.select_state_component.is_selected()

func deselect_all():
	for element: EGBaseElement in collection.get_elements():
		if element.select_state_component.is_selected():
			element.select_state_component.deselect()
	
## Utils
func add_element(element):
	collection.add_element(element)
	element.global_position = Vector2(randi_range(-10000, 10000),randi_range(-10000, 10000))
	element.select_state_component.select_state_changed.connect(_on_selection_changed)
	return element

func _on_selection_changed():
	selection_changed.emit()

