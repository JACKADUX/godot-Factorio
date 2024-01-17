class_name InventoryItem extends Resource

@export var item:= BaseItem.new()
@export var slot_index:int = -1
@export var count:int = 1

var texture:Texture2D:
	get: return item.texture
var id:int:
	get: return item.id

## Statics
static func create_from(item:BaseItem, count:int=1):
	var inventory_item := InventoryItem.new()
	inventory_item.item = item
	inventory_item.count = count
	return inventory_item
