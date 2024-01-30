class_name EntityInserter1 extends BaseEntity

var _busy_timer :CustomTimer
var _idle_timer :CustomTimer

var input_coords:Vector2i
var output_coords:Vector2i

var _input_invantory:Inventory
var _output_invantory:Inventory
var _hand_slot:=HandSlot.new()

var _hold_count = 2
var _busy_duration:float = 1
var _idle_duration:float = 0.5

## Overrides
func get_item_id() -> String:
	return "INSERTER_1"

func get_entity_data() -> Dictionary:
	var data = super()
	return data

func construct():
	need_work = true
	#_hand_slot.slot_changed.connect(_on_hand_slot_changed)
	_busy_timer = CustomTimer.new(_busy_duration)
	_busy_timer.timeout.connect(
		func(): work_state = WorkeState.End
		)
	_busy_timer.start()
	
	_idle_timer = CustomTimer.new(_idle_duration)
	_idle_timer.timeout.connect(
		func(): work_state = WorkeState.Start
		)
	_idle_timer.start()
	
	input_coords = coords - Directions[direction]
	output_coords = coords + Directions[direction]
	#
	_input_invantory = _get_inventory(input_coords)
	_output_invantory = _get_inventory(output_coords)
	
func update(delta:float):
	match work_state:
		WorkeState.Idle:
			_idle_timer.update(delta)
			_update_insert()
		WorkeState.Start:
			_start_insert()
		WorkeState.Busy:
			_busy_timer.update(delta)
			_update_insert()
		WorkeState.End:
			_end_insert()
			

func _entity_notification(what:int):
	var EntityNotification = _entity_manager.EntityNotification 
	match what:
		EntityNotification.NewEntityConsturct:
			_input_invantory = _get_inventory(input_coords)
			_output_invantory = _get_inventory(output_coords)
			
## Utils

func _get_inventory(side_coords:Vector2i): ## FIXME: 需要更好的实现
	var _entity :BaseEntity = _entity_manager.get_entity_by_coords(side_coords)
	if not _entity:
		return 
	var data = _entity.get_entity_data()
	if not data.has("inventory"):
		return 
	return data.inventory

func _start_insert():
	if not _hand_slot.is_hand_empty():
		work_state = WorkeState.End
		return 
	if not _input_invantory:
		return
	var _slots = _input_invantory.get_not_null_slots()
	if not _slots:
		return 
	var result = _hand_slot.take_item_to_hand(_input_invantory, _slots[0].get_item(), _hold_count)
	if not result:
		return 
	work_state = WorkeState.Busy
	
func _update_insert():
	pass
	#print("insert progress: ",_busy_timer.time_left)
	
func _end_insert():
	if _hand_slot.is_hand_empty():
		work_state = WorkeState.Start
		return 
	if not _output_invantory:
		return
	var res =_hand_slot.put_item_from_hand(_output_invantory, _hand_slot.get_count())
	if not res:
		return 
	work_state = WorkeState.Idle
	

	
	

