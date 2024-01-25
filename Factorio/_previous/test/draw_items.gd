extends Node2D


func _ready():
	add_to_group("debug_draw")

	
func _process(delta):
	queue_redraw()
