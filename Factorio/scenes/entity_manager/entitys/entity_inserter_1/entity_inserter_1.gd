class_name EntityInserter1 extends BaseEntity

var input_coords:Vector2i:
	get: return coords - Directions[direction]
var output_coords:Vector2i:
	get: return coords + Directions[direction]

var _input_inventory:Inventory
var _output_inventory:Inventory

var _inventory:Inventory

var _transfer_count = 2
var _busy_timer :CustomTimer
var _busy_duration:float = 1
var _idle_timer :CustomTimer
var _idle_duration:float = 0.5

var _WSC : WorkStateComponent

func _init(id:int):
	super(id)
	is_worker = true
	construct_notification = true
	deconstruct_notification = true
	
	_WSC = WorkStateComponent.new()
	add_component(_WSC)
	
## Overrides
func get_entity_data() -> Dictionary:
	var data = super()
	data["inventory"] = _inventory
	data["work_progress"] = _get_progress()
	return data

func construct(_entity_manager):
	super(_entity_manager)
	
	_inventory = Inventory.new(1)
	
	_busy_timer = CustomTimer.new(_busy_duration)
	_busy_timer.timeout.connect(_WSC.to_end_state)
	_busy_timer.start()
	
	_idle_timer = CustomTimer.new(_idle_duration)
	_idle_timer.timeout.connect(_WSC.to_start_state)
	_idle_timer.start()

	#
	_update_inventory(_entity_manager.get_entity_by_coords(input_coords))
	_update_inventory(_entity_manager.get_entity_by_coords(output_coords))
	

func _entity_notification(msg, what:NotificationType):
	match what:
		NotificationType.Construct:
			# msg = entity
			_update_inventory(msg)
		NotificationType.Deconstruct:
			# msg = entity
			_update_inventory(msg)	
		NotificationType.Work:
			#msg = delta 
			if _WSC.is_idel_state():
				_idle_timer.update(msg)
				_update_insert()
			elif _WSC.is_start_state():
				_start_insert()
			elif _WSC.is_busy_state():
				_busy_timer.update(msg)
				_update_insert()
			elif _WSC.is_end_state():
				_end_insert()
## Utils
func _get_progress():
	return (1-(_busy_timer.time_left/_busy_duration))*100

func _update_inventory(_entity :BaseEntity): ## FIXME: 需要更好的实现
	if not _entity:
		return 
	var data = _entity.get_entity_data()	
	if not data.has("inventory"):
		return 
	var rect = Rect2i(data.coords, data.size)
	if rect.has_point(input_coords):
		if _entity._constructed:
			_input_inventory = data.inventory
		else:
			_input_inventory = null
	elif rect.has_point(output_coords):
		if _entity._constructed:
			_output_inventory = data.inventory	
		else:
			_output_inventory = null
		
func _start_insert():
	var slot = _inventory.get_slot(0)
	if slot:
		_WSC.to_end_state()
		return 
	if not _input_inventory:
		return
	var _slots = _input_inventory.get_slots()
	if not _slots:
		return 
	Inventory.transfer(_input_inventory, _slots[0][0], _transfer_count, _inventory)
	if not _inventory.get_slot(0):
		return 
	_WSC.to_busy_state()
	
func _update_insert():
	pass
	#work_progress.emit(progress)
	
	#print("insert progress: ",_busy_timer.time_left)
	
func _end_insert():
	var slot = _inventory.get_slot(0)
	if not slot:
		_WSC.to_start_state()
		return 
	if not _output_inventory:
		return
	Inventory.transfer(_inventory, slot[0], slot[1], _output_inventory)
	if _inventory.get_slot(0):
		return 
	_WSC.to_idel_state()
	

	
	

