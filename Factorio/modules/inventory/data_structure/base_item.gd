class_name BaseItem extends Resource

#Types {Ingredient, Building}

@export var id:int = 0
@export var name:String = ""
@export var texture:Texture2D

func is_same_type(other:BaseItem):
	return other and id == other.id
