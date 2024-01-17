class_name InventoryData extends Resource

var inventory_items :Array[InventoryItem]= []

## Interface
func get_inventory_items():
	return inventory_items

func add_inventory_item(value:InventoryItem):
	if not value in inventory_items:
		inventory_items.append(value)
	
func remove_inventory_item(value:InventoryItem):
	if value in inventory_items:
		inventory_items.erase(value)

func stack_inventory_item(item:InventoryItem, other_item:InventoryItem):
	if item.id == other_item.id:
		item.count += other_item.count
		return item

