class_name BaseItem extends Resource

@export var id:String = ""
var name:String = ""
var texture:Texture2D

func is_same_type(other:BaseItem):
	return other and id == other.id
