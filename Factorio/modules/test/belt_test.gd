extends Node2D

@onready var transport_belt = $TransportBelt
@onready var transport_belt_3 = $TransportBelt3

@onready var tile_map = $TileMap

func _ready():
		
	var tile_set = tile_map.tile_set as TileSet
	var tile_source = tile_set.get_source(0)
	tile_source.set_tile_animation_speed(Vector2i(0,0), transport_belt.speed)
	tile_source.set_tile_animation_speed(Vector2i(0,1), transport_belt.speed)
	tile_source.set_tile_animation_speed(Vector2i(0,2), transport_belt.speed)
	tile_source.set_tile_animation_speed(Vector2i(0,3), transport_belt.speed)

	transport_belt.input_by(Enums.Items.Coal)


func _on_timer_timeout():
	transport_belt.input_by(Enums.Items.Coal)
	if randf()>0:
		return 
	if transport_belt_3.wait_for_output():
		transport_belt_3.output(transport_belt_3.items[0])
	
