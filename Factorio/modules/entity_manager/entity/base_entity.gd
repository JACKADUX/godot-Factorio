class_name BaseEntity

var item_id :String = "" : get=get_item_id
var coords:Vector2   # grid_index

func get_item_id() -> String:
	return ""

func get_entity_data() -> Dictionary:
	var data = {}
	data["id"] = item_id
	data["coords"] = coords
	return data

func construct():
	pass

func deconstruct():
	pass

func update(delta:float):
	pass
	#print(item_id," : ", self, " is working!")

