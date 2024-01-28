class_name EntityIronChest extends BaseEntity

## Iron Chest
var inventory:Inventory #:= Inventory.create(32)

func get_item_id() -> String:
	return "IRON_CHEST"
