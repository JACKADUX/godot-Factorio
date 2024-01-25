class_name TransportBelt extends Node2D

var items = []

var transport_path := Curve2D.new()
var maxstore = 4
var belt_speed = 1 # 8 i/s
@onready var speed = (belt_speed+maxstore)*(Globals.GridSize/maxstore)  # 96px/s
@onready var time_spent :float = Globals.GridSize/float(speed)
@onready var part_time :float = time_spent/maxstore

var _align :float = 0
var _align_avalible = true
var _all_stucked = false

class BeltItem:
	var item
	var time :float = 0
	var stucked := false
	var wait = true
	func _init(_item):
		item = _item
	
	func update(delta):
		time += delta
		
	func clear():
		time = 0
		wait = true
		stucked = false
		return self

@export var direction_index :int = 0 # 0 90 180 270
var directions =[Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
var direction :Vector2i = directions[direction_index]

@export var next_belt: TransportBelt
@export var prev_belt: TransportBelt

 
## Virtual
func _ready():
	set_direction(direction_index)
	create_transport_path()
	
func _process(delta):
	update_align(delta)
	update_belt_items(delta)
	auto_next()

func _draw():
	var length = transport_path.get_baked_length()
	for belt_item in items:
		if belt_item.wait:
			continue
		var duration = belt_item.time/time_spent
		var center = transport_path.sample_baked(duration*length)
		draw_circle(center, 4, Color.SKY_BLUE)
	draw_polyline(transport_path.tessellate_even_length(5,1), Color.AQUA, 1)

## Interface

func wait_for_output():
	if not items:
		return false
	var belt_item = items[0]
	return belt_item.stucked and belt_item.time >= time_spent

func auto_next():
	if not wait_for_output() or not next_belt:
		return false
	
	if not next_belt.allow_input():
		return 
	var belt_item = items[0]
	if next_belt.prev_belt == self:
		next_belt.input(output(belt_item))
	return true
	
func create_transport_path():
	transport_path.clear_points()
	var offset = direction*Globals.GridSizeHalf
	if not prev_belt:
		transport_path.add_point(-offset+Globals.GridSizeHalfVector)
		transport_path.add_point(offset+Globals.GridSizeHalfVector)
	else:
		transport_path.add_point(prev_belt.get_end_point()-global_position)
		transport_path.add_point(Globals.GridSizeHalfVector)
		transport_path.add_point(offset+Globals.GridSizeHalfVector)
	
func get_start_point():
	return global_position+transport_path.get_point_position(0)
	
func get_end_point():
	var offset = direction*Globals.GridSizeHalf
	return global_position+offset+Globals.GridSizeHalfVector

func next_direction():
	set_direction(direction_index+1)
	
func set_direction(index:int):
	direction_index = index%4
	direction = directions[direction_index]

func update_align(delta):
	_align += delta
	if _align >= part_time:
		_align_avalible = true
		_align -= part_time

func update_belt_items(delta):
	if _all_stucked:
		return
	var stuck_count = 0
	for belt_item in items:
		if belt_item.wait and _align_avalible:
			belt_item.wait = false
			_align_avalible = false
			break
		if belt_item.wait:
			break
		belt_item.update(delta)
		var aim_time = time_spent-stuck_count*part_time
		if belt_item.time >= aim_time:
			belt_item.time = aim_time
			belt_item.stucked = true
			stuck_count += 1
	if stuck_count >= maxstore:
		_all_stucked = true
	queue_redraw()

func allow_input():
	return items.size() < maxstore and not _all_stucked

func new_belt_item(item):
	return BeltItem.new(item)

func input_by(item):
	return input(new_belt_item(item))

func input(belt_item:BeltItem):
	if not allow_input():
		return false
	items.append(belt_item)
	return true
	
func output(belt_item:BeltItem):
	items.erase(belt_item)
	_all_stucked = false
	return belt_item.clear()




	







































