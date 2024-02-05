class_name EntityTransportBelt1 extends BaseEntity

var _work_timer:CustomTimer

var _WSC : WorkStateComponent

var input_coords:Vector2i:
	get: return coords - Directions[direction]
var output_coords:Vector2i:
	get: return coords + Directions[direction]

var _max_count :int = 4
var belt_speed :int = 15 # item/s
var pixcel_speed:int = 92 # px/s   (Globals.Size/_max_count) * (15/line_count) = 60 + Globals.Size = 92
var transport_duration = 8/92.0

enum SlotIndex {
	Null,
	SLOT4,  # -> 1
	SLOT3,
	SLOT2,
	SLOT1,  # -> 4
}


var slots_1 = []
var _bits = 0  # -> 0000

var insert_first = 8
# 位运算？

func has_item_in_bit(index:SlotIndex):
	return (_bits & 1 << (index - 1)) > 0

func set_item_in_bit(index:SlotIndex):
	return _bits | 1 << (index - 1)

func get_item_in_bit(index:SlotIndex):
	return _bits & ~( 1 << (index - 1))
	

func move_belt():
	pass
	
func _init():
	is_worker = true
	construct_notification = true
	deconstruct_notification = true
	_WSC = WorkStateComponent.new()
	add_component(_WSC)

func get_item_id() -> String:
	return "TRANSPORT_BELT_1"

func get_entity_data() -> Dictionary:
	var data = super()
	return data

func construct(_entity_manager):
	super(_entity_manager)
	_WSC.to_busy_state()
	
func _entity_notification(msg, what:NotificationType):
	match what:
		NotificationType.Construct:
			# msg = entity
			pass
		NotificationType.Deconstruct:
			# msg = entity
			pass
		NotificationType.Work:
			#msg = delta 
			if _WSC.is_idle_state():
				_idel_work()
			elif _WSC.is_start_state():
				_start_work()
			elif _WSC.is_busy_state():
				_update_work()
			elif _WSC.is_end_state():
				_end_work()

func _idel_work():
	pass
func _start_work():
	pass
func _update_work():
	pass
	
func _end_work():
	pass

