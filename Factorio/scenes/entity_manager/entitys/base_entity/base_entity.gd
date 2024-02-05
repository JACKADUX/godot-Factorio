class_name BaseEntity

static var Directions :Array[Vector2i]= [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]

enum NotificationType {Construct, Work, Deconstruct}

enum ComponentType {WorkState, EnergyState}
var _components := []

var _constructed:= false

var id :int = 0
var coords:=Vector2i.ZERO  # cell
var size:=Vector2i.ZERO  # cell
var direction:int= 0

var is_worker:= false
var construct_notification := false
var deconstruct_notification := false

func _init(id:int):
	self.id = id

func get_item_id() -> int:
	return id

func get_entity_data() -> Dictionary:
	var data = {}
	data["id"] = id
	data["coords"] = coords
	data["size"] = size
	data["direction"] = direction
	return data

func construct(em):
	_constructed = true

func deconstruct():
	_constructed = false
	
func _entity_notification(msg, what:NotificationType):
	pass
	
# ----------------------- component
func add_component(component:EntityBaseComponent):
	_components.append(component)

func remove_component(component:EntityBaseComponent):
	_components.erase(component)

func get_component(type:ComponentType):
	for c in _components:
		match type:
			ComponentType.WorkState:
				if c is WorkStateComponent:
					return c
			ComponentType.EnergyState:
				if c is EnergyStateComponent:
					return c

func has_component(type:ComponentType):
	return get_component(type) != null

# 





