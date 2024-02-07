class_name EntityTransportBelt1 extends BaseEntity

var _WSC : WorkStateComponent

var input_coords:Vector2i:
	get: return coords - Directions[direction]
var output_coords:Vector2i:
	get: return coords + Directions[direction]

var _max_count :int = 4
var belt_speed :int = 15 # item/s
var pixcel_speed:int = 92 # px/s   (Globals.Size/_max_count) * (15/line_count) = 60 + Globals.Size = 92
var transport_duration = 8/92.0

var _belt_1 := SingleBelt.new()

var _input_inventory:Inventory
var _output_inventory:Inventory

var _timer :float = 0

func _init(id:int):
	super(id)
	is_worker = true
	construct_notification = true
	deconstruct_notification = true
	_WSC = WorkStateComponent.new()
	add_component(_WSC)


func get_entity_data() -> Dictionary:
	var data = super()
	data["input_inventory"] = _input_inventory
	data["output_inventory"] = _output_inventory
	return data

func construct(_entity_manager):
	super(_entity_manager)
	
	_input_inventory = Inventory.new(4)
	_input_inventory.input(1001, 500)
	
	_output_inventory = Inventory.new(4)
	_WSC.to_start_state()
	
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
				_timer += msg
				if _timer >= transport_duration:
					_timer -= transport_duration
					_update_work()
			elif _WSC.is_end_state():
				_end_work()

func _idel_work():
	pass
	
func _start_work():
	#_bit_set_1()
	_WSC.to_busy_state()
	
func _update_work():
	#if _bit_is_full():  # 1111
	#	_WSC.to_end_state()
	#	return 
	#_bit_shift()
	_WSC.to_end_state()
	
func _end_work():
	#_bit_clear_4()
	_WSC.to_start_state()

# ------- bit
