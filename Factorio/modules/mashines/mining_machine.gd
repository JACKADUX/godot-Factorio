extends Node2D

var _transports = []
var _inputs := StorageCollection.new()
var _outputs := StorageCollection.new()
var _converter = Converter.new()

var mine_types = [Enums.Items.Coal, Enums.Items.IronOre, Enums.Items.CopperOre]
var _temp_inputs := StorageCollection.new()

@onready var timer_converter = %TimerConverter


func _ready():
	timer_converter.timeout.connect(_on_timer_converter_timeout)

func add_input(storage:Storage):
	if storage.is_empty():
		return
	if storage.get_type() not in mine_types:
		return 
	_temp_inputs.append_storage(storage)
	
func assign_inputs():
	_temp_inputs.remove_empty_storage()
	if _temp_inputs.is_empty():
		return 
	if not _outputs.is_empty() and not _outputs.is_all_storage_empty():
		return 
		
	var data = _temp_inputs.get_type_total_data()
	var avalible = []
	for mine_type in mine_types:
		if data.has(mine_type):
			avalible.append(mine_type)
	if not avalible:
		_temp_inputs.clear()
		return 
	var mine_type = avalible.pick_random()
	var storage = data[mine_type].storage_list[0]
	storage.storage_changed.connect(_on_storage_changed.bind(storage, "input"))
	var formula:Formula
	if mine_type == Enums.Items.Coal:
		formula = Enums.formula_coal_mine()
		
	_converter.set_formula(formula)
	_inputs.clear()
	_inputs.append_storage(storage)
	_outputs = formula.get_results()
	_outputs.set_all_storage_to_empty()

func update_transports():
	for transport:Transport in _transports:
		transport.transport()

func start_converter():
	if _converter.consume_inputs(_inputs):
		print("convert_started")
		timer_converter.start(_converter.get_time_cost())

func end_converter():
	if _converter.collect_outputs(_outputs):
		print("convert_finished")
		print(_outputs.get_type_total_data())
	else:
		print("can't releas output")

func update():
	update_transports()
	start_converter()
	
## OnSignals
func _on_storage_changed(storage:Storage, in_or_out):
	print(in_or_out,": ",storage.get_number())
	if in_or_out == "input":
		if storage.is_empty():
			assign_inputs.call_deferred()


func _on_timer_converter_timeout():
	end_converter()






















