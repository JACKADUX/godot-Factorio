class_name InventorySlot extends Resource


@export var item:BaseItem: set = set_item, get = get_item
@export var count:int = 0: set = set_count, get = get_count

## Interface
func is_same_type(other:InventorySlot):
	if not item or not other.item:
		return false
	return item.is_same_type(other.item)
		
func is_empty():
	return count <= 0

func set_item(value:BaseItem):
	item = value

func get_item():
	return item

func set_count(value:int):
	count = value

func get_count():
	return count

func change(item:BaseItem, count:int):
	set_item(item)
	set_count(count)
	
func clear():
	item = null
	count = 0
