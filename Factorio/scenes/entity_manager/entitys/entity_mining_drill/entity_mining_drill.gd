class_name EntityMiningDrill extends BaseEntity

var _work_timer:CustomTimer
var _fuel_timer:CustomTimer

var output_coords:Vector2i:
	get: return coords + Directions[direction]
	
var _input_inventory:Inventory
var _fuel_inventory:Inventory
var _output_inventory:Inventory
	
var _WSC : WorkStateComponent

#
var mining_speed = 0.25  # item/s
var mining_area = Vector2i(2,2)
var expected_resources = []  # InventorySlot
var productivity = 0.5  # +50%  每生产2个就会多给1个
var _extrue_product :float = 0
var productivity_progress:float = 0
var _fuel_duration :float = 0

var _work_duration:float:
	get: return 1/mining_speed
#

var consumes_burnable_fuel = true
var max_consumption = 150  # kw

var _id:int  # 目标矿物的id


func _init(id:int):
	super(id)
	is_worker = true
	_WSC = WorkStateComponent.new()
	add_component(_WSC)


func get_entity_data() -> Dictionary:
	var data = super()
	data["input_inventory"] = _input_inventory
	data["output_inventory"] = _output_inventory
	data["fuel_inventory"] = _fuel_inventory
	data["productivity_progress"] = productivity_progress*100
	data["work_progress"] = _get_progress()*100
	data["fuel_progress"] = _get_fuel_progress()*100
	return data
	
func _get_progress():
	return (1-(_work_timer.time_left/_work_duration))

func _get_fuel_progress():
	return _fuel_timer.time_left/_fuel_duration

func construct(_entity_manager):
	super(_entity_manager)
	
	_input_inventory = Inventory.new(1)
	_input_inventory.input(1001, 100)
	
	_fuel_inventory = Inventory.new(1)
	_fuel_inventory.input(1001, 100)
	
	_output_inventory = Inventory.new(1)
	
	_work_timer = CustomTimer.new()
	_work_timer.timeout.connect(_WSC.to_end_state)
	#_work_timer.start()
	
	_fuel_timer = CustomTimer.new()
	_fuel_timer.one_time = true
	#_fuel_timer.timeout.connect(_feed_fuel)
	#_fuel_timer.start()

	_WSC.to_start_state()
	##
	#_update_inventory(_entity_manager.get_entity_by_coords(input_coords))
	#_update_inventory(_entity_manager.get_entity_by_coords(output_coords))

func _entity_notification(msg, what:NotificationType):
	match what:
		NotificationType.Work:
			#msg = delta 
			if _WSC.is_idel_state():
				_idel_work()
				return 
				
			if _fuel_timer.is_stoped():
				if not _feed_fuel():
					return
			_fuel_timer.update(msg)
			if _WSC.is_start_state():
				_start_work()
			elif _WSC.is_busy_state():
				_work_timer.update(msg)
				_update_work()
			elif _WSC.is_end_state():
				_end_work()



func _feed_fuel() -> bool:
	var slot = _fuel_inventory.get_slot(0)
	if not slot:
		return false
	var id = slot[0]
	var fuel_value = DatatableManager.get_fuel_value(id)
	if not fuel_value:
		return false
	_fuel_duration = DatatableManager.get_fuel_time(fuel_value, max_consumption)
	slot[1] = slot[1]-1
	_fuel_timer.start(_fuel_duration)
	return true


func _idel_work():
	# 没矿 -> 空闲
	## FIXME: 在矿挖完后可以断开 _entity_notification 避免无效调用
	_id = 0
	_work_timer.stop()

func _start_work():
	var slots = _input_inventory.get_slots()
	if not slots:
		_WSC.to_idel_state()
		return 
	_id = slots[0][0]
	# 只要存在矿就先开始挖,挖完再拿
	_work_timer.start(_work_duration)
	_WSC.to_busy_state()

func _update_work():
	## FIXME:重复
	productivity_progress = _get_progress()*productivity+_extrue_product
	if productivity_progress >= 1:
		_extrue_product = 0
		var slots = _input_inventory.get_slots()
		if not slots:
			_WSC.to_idel_state()
			return 
		var count = 1
		Inventory.transfer(_input_inventory, _id, count, _output_inventory)
		
func _end_work():
	var slots = _input_inventory.get_slots()
	if not slots:
		_WSC.to_idel_state()
		return 
	
	_extrue_product += productivity
	var count = 1
	Inventory.transfer(_input_inventory, _id, count, _output_inventory)
	## FIXME: 目标空间满了的情况也要考虑！
	_WSC.to_start_state()

















