class_name BaseEntity extends RefCounted

var item_id :String = "" : get=get_item_id
var coords:Vector2   # grid_index

func get_item_id() -> String:
	return ""

func construct():
	pass

func deconstruct():
	pass

func update(delta:float):
	pass
	#print(item_id," : ", self, " is working!")

