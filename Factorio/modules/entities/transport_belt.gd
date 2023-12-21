class_name TransportBelt extends Node2D

var items = []

var maxstore = 5
var belt_speed = 1 # i/s
var time_spent = 1/float(belt_speed)  # 0.125 s/i
var part_time = time_spent/4.0

@onready var speed = Globals.GridSize/ time_spent  # 320 px/s

var direction := Vector2i(1,0)  # X+
var all_stucked = false

@export var next_belt:TransportBelt

@onready var font = FontFile.new()

class BeltItem:
	var item
	var time
	var stucked := false
	func _init(_item):
		item = _item
		time = 0
	
	func update(delta):
		time += delta
	
func _ready():
	pass
	#input(Enums.Items.Coal)

func _process(delta):
	to_next()
	update(delta)
	
	
func update(delta):
	# FIXME: 会有像素抖动
	if all_stucked:
		return
	var stuck_count = 0
	var last_time = time_spent
	for belt_item in items:
		if last_time < part_time+delta:
			# 防止重叠
			continue
		belt_item.update(delta)
		var aim_time = time_spent-stuck_count*part_time
		if belt_item.time > aim_time:
			belt_item.time = aim_time
			belt_item.stucked = true
			stuck_count += 1
		last_time = belt_item.time
	if stuck_count == maxstore:
		all_stucked = true
	queue_redraw()

func to_next():
	if not items or not next_belt:
		return 
	var belt_item = items[0]
	if belt_item.time == time_spent and next_belt.allow_input():
		next_belt.input(output(belt_item))

func allow_input():
	return items.size() < maxstore and not all_stucked

func input(item):
	if not allow_input():
		return false
	items.append(BeltItem.new(item))
	return true
	
func output(belt_item):
	items.erase(belt_item)
	all_stucked = false
	return belt_item.item

func _draw():
	var mid = Globals.GridSize*0.5
	var hide_next = false
	for belt_item in items:
		if hide_next:
			continue
		if belt_item.time < part_time:
			hide_next = true
		var duration = belt_item.time/time_spent
		var x = lerp(0, Globals.GridSize, duration)
		draw_circle(Vector2(x, mid), 4, Color.SKY_BLUE)
		#var rect = Rect2(Vector2(x-4, mid-4), Vector2(8,8))
		#draw_rect(rect, Color.SKY_BLUE, true)
		#draw_string(font, global_position, ("%.3f" % (belt_item.time)) ,HORIZONTAL_ALIGNMENT_LEFT)
	


	



































