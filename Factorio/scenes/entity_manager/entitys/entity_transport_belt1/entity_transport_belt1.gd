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

var input_transport_belt:EntityTransportBelt1

var _belt_1 := SingleBelt.new()

func _init(id:int):
	super(id)
	is_worker = true
	construct_notification = true
	deconstruct_notification = true
	_WSC = WorkStateComponent.new()
	add_component(_WSC)


func get_entity_data() -> Dictionary:
	var data = super()
	#data["belt"] = [_belt_1._slots, _belt_1._bits]
	return data

func construct(_entity_manager):
	super(_entity_manager)
	
	_work_timer = CustomTimer.new(transport_duration)
	_work_timer.timeout.connect(_WSC.to_end_state)
	_work_timer.start()

	_WSC.to_start_state()

func get_output():
	return _belt_1.pop_end()

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
			if _WSC.is_idel_state():
				_idel_work()
			elif _WSC.is_start_state():
				_start_work()
			elif _WSC.is_busy_state():
				_work_timer.update(msg)
				_update_work()
			elif _WSC.is_end_state():
				_end_work()

func _idel_work():
	if input_transport_belt:
		_WSC.to_start_state()
	
func _start_work():
	if input_transport_belt and _belt_1.has_input_space():
		var from_input = input_transport_belt.get_output()
		if from_input:
			_belt_1.push_front(from_input)
	_WSC.to_busy_state()
	
func _update_work():
	pass
	
func _end_work():
	_belt_1.shift()
	_WSC.to_start_state()
