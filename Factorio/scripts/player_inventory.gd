class_name PlayerInventory extends Inventory

func _init(number:int=0) :
	super(number)
	inventory_changed.connect(_auto_arrange)
	
func _feed_data():
	var Items = DatatableManager.base_items
	input(Items.COAL, 12)
	input(Items.IRON_ORE, 8)
	input(Items.MINING_DRILL, 2)
	input(Items.INSERTER_1, 2)
	input(Items.IRON_CHEST, 2)
	input(Items.ASSEMBLING_MACHINE_1, 2)
	input(Items.TRANSPORT_BELT_1, 2)
	_auto_arrange()
	inventory_changed.emit()
	
## Utils
func _auto_arrange():
	# 直接比较id 进行排序
	_sort(func(a,b): return a < b)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
