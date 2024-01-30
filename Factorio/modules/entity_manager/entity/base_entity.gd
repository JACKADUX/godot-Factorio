class_name BaseEntity

static var Directions :Array[Vector2i]= [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]

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
		EntityNotification.NewConsturct:
			pass
			





