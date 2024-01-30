class_name PlayerInventory extends Inventory

func _init(number:int=0) :
	super(number)
	invetory_changed.connect(_auto_arrange)
	
func _feed_data():
	var Items = DatatableManager.base_items
	add_item(Items.COAL, 12)
	add_item(Items.IRON_ORE, 8)
	add_item(Items.MINING_DRILL, 2)
	add_item(Items.INSERTER_1, 2)
	add_item(Items.IRON_CHEST, 2)
	add_item(Items.ASSEMBLING_MACHINE_1, 2)
	_auto_arrange()
	emit_signal("invetory_changed")

## Utils
func _auto_arrange():
	_sort(func(a,b):
			return DatatableManager.get_item_type(a.id) < DatatableManager.get_item_type(b.id)
	)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
