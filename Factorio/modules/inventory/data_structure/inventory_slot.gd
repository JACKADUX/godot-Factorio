class_name InventorySlot extends Resource

@export var item:BaseItem 
@export var count:int = 0

## Interface
func is_same_type(other:InventorySlot):
	return item == other.item
		
func is_empty():
	return count == 0

func set_item(value:BaseItem):
	item = value
func set_count(value:int):
	count = value
	
func change(item:BaseItem, count:int):
	set_item(item)
	set_count(count)
