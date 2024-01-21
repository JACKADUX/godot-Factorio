class_name BaseItem extends Resource

#Types {Ingredient, Logic, Building}

@export var id:int = 0
@export var name:String = ""
@export var texture:Texture2D

func is_same_type(other:BaseItem):
	return id == other.id
