class_name EntityInserter1 extends BaseEntity

var _timer :CustomTimer

var input_coords:Vector2i
var output_coords:Vector2i

var _input_invantory:Inventory
var _output_invantory:Inventory
var _hold_slot:InventorySlot

var _intert_time:float = 2
var _stucked := false
var _hold_count = 1

func get_item_id() -> String:
	return "INSERTER_1"

func get_entity_data() -> Dictionary:
	var data = super()
	return data

func construct():
	_timer = CustomTimer.new(_intert_time)
	_timer.timeout.connect(_on_timeout)
	_timer.one_time = true
	
	input_coords = coords - Directions[direction]
	output_coords = coords + Directions[direction]
	
	#
	_input_invantory = _get_inventory(input_coords)
	if not _input_invantory:
		return
	_output_invantory = _get_inventory(output_coords)
	_start_insert()
	
func update(delta:float):
	_timer.update(delta)
	_update_insert()

## Utils
func _check_inventory():
	_input_invantory = _get_inventory(input_coords)
	_output_invantory = _get_inventory(output_coords)
	if _stucked:
		_end_insert()

func _get_inventory(side_coords:Vector2i):
	var _entity :BaseEntity = _entity_manager.get_entity_by_coords(side_coords)
	if not _entity:
		return 
	var data = _entity.get_entity_data()
	if not data.has("inventory"):
		return 
	return data.inventory

func _start_insert():
	_stucked = false
	if _hold_slot:
		return 
	if not _input_invantory:
		return
	var _slots = _input_invantory.get_valid_slots()
	if not _slots:
		return 
	var _slot = _slots[0]
	if _slot.is_empty():
		return 
	
	var item = _slot.get_item()
	var count = _slot.get_count()
	var hold_count = _hold_count
	if count < hold_count:
		hold_count = count
	_slot.set_count(count-hold_count)
	_hold_slot = InventorySlot.new(item, hold_count)
	_timer.start()

func _update_insert():
	pass
	#print("insert progress: ",_timer.time_left)
	
func _end_insert():
	if not _hold_slot:
		return 
	if not _output_invantory:
		return
	var res = _output_invantory.add_item(_hold_slot.get_item(), _hold_slot.get_count())
	if res:
		_hold_slot = null
		_start_insert()
	else:
		_stucked = true

## OnSignals
func _on_timeout():
	_end_insert()

func _entity_notification(what:int):
	var EntityNotification = _entity_manager.EntityNotification 
	match what:
		EntityNotification.NewConsturct:
			_check_inventory()
			
