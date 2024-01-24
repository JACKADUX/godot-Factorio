extends InventoryUI

var _block_signal:=false

func _ready():
	_feed_data()
	_initialize()
	
func _feed_data():
	_inventory = Inventory.create(16)
	_inventory.get_slot(2).change(Items.COAL, 12)
	_inventory.get_slot(4).change(Items.COAL, 8)
	_inventory.get_slot(7).change(Items.IRON_ORE, 2)
	_auto_arrange.call_deferred()


## Interface
func hold_item(value:BaseItem):
	if not value:
		return 
	for slot_ui:InventorySlotUI in get_children():
		var item :BaseItem = slot_ui.get_item()
		if not item:
			continue
		if item.is_same_type(value):
			Globals.inventory_slot_clicked.emit(self, slot_ui)
			return
	
	
## Utils
func _on_slot_changed(slot_ui:InventorySlotUI):
	_auto_arrange()
	super(slot_ui)
	
func _auto_arrange():
	## FIXME: slot_ui.set_item 和 slot_ui.set_count 连续调用会出问题 需要使用 slot_ui.change
	if _block_signal:  
		# 防止循环调用
		return
	_block_signal = true
	var count_data = get_item_count_data()
	var order_items = count_data.keys()
	order_items.sort_custom(func(a,b): return a.id < b.id)
	for slot_ui:InventorySlotUI in get_children():
		slot_ui.clear()
	
	for i in order_items.size():
		var slot_ui := get_child(i) as InventorySlotUI
		var item:BaseItem = order_items[i]
		slot_ui.change(item, count_data[item])
	_block_signal = false
		
		
		
		
		
		
