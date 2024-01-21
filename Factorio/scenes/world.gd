extends Node2D

@onready var center_container_2 = $CanvasLayer/Control/CenterContainer2


func _ready():
	pass
		
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_E:
				center_container_2.visible = not center_container_2.visible
