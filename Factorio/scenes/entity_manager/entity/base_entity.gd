class_name BaseEntity

signal work_state_changed
signal energy_state_changed

static var Directions :Array[Vector2i]= [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]

enum WorkeState {Idle, Start, Busy, End}
var work_state := WorkeState.Idle:
	set(value):
		work_state = value
		work_state_changed.emit()
var need_work := false
		
enum EnergyState {NoPower, Normal, LowPower}
var energy_state := EnergyState.NoPower:
	set(value):
		energy_state = value
		energy_state_changed.emit()
var need_energy := false


var _entity_manager:EntityManager

var item_id :String = "" : get=get_item_id
var coords:=Vector2i.ZERO  # cell
var direction:int= 0

func get_item_id() -> String:
	return ""

func get_entity_data() -> Dictionary:
	var data = {}
	data["id"] = item_id
	data["coords"] = coords
	data["direction"] = direction
	return data

func construct():
	pass

func deconstruct():
	pass

func update(delta:float):
	pass
	#print(item_id," : ", self, " is working!")

func _entity_notification(what:int):
	var EntityNotification = _entity_manager.EntityNotification 
	match what:
		EntityNotification.NewEntityConsturct:
			pass
			





