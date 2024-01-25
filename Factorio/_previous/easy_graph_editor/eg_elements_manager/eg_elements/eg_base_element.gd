class_name EGBaseElement extends Node2D

const GroupNameMouseInside = "mouse_inside_elements"
const GroupNameVisable = "visable_elements"


@onready var select_state_component := $SelectStateComponent as SelectStateComponent
@onready var transform_component := $TransformComponent as TransformComponent
@onready var eg_area_component := $EGAreaComponent as EGAreaComponent

@onready var visible_screen_enabler := $VisibleOnScreenEnabler2D

func _ready(): 
	eg_area_component.rect_changed.connect(func():visible_screen_enabler.rect = eg_area_component.rect)
	visible_screen_enabler.screen_entered.connect(_on_screen_entered)
	visible_screen_enabler.screen_exited.connect(_on_screen_exited)
	eg_area_component.mouse_entered.connect(_on_mouse_entered)
	eg_area_component.mouse_exited.connect(_on_mouse_exited)
	visible_screen_enabler.rect = eg_area_component.rect



## Utils
func get_area() -> Rect2:
	return eg_area_component.rect

## OnSignals
func _on_mouse_entered():
	add_to_group(GroupNameMouseInside)

func _on_mouse_exited():
	remove_from_group(GroupNameMouseInside)

func _on_screen_entered():
	add_to_group(GroupNameVisable)

func _on_screen_exited():
	_on_mouse_exited()
	remove_from_group(GroupNameVisable)
