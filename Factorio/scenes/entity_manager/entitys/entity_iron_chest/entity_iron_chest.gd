class_name EntityIronChest extends BaseEntity

## Iron Chest
var inventory := Inventory.new(32)

func get_entity_data() -> Dictionary:
	var data = super()
	data["inventory"] = inventory
	return data
