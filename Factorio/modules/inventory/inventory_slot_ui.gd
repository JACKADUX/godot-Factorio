class_name InventorySlotUI extends Button

signal slot_changed

@onready var texture_rect = %TextureRect
@onready var label_count = %LabelCount
@onready var label_name = %LabelName

var inventory_slot := InventorySlot.new()


func _ready():
	update()
		
## Interface
func can_exchange(other_slot_ui:InventorySlotUI):
	return true

func exchange(other_slot_ui:InventorySlotUI):
	## NOTE: 如果调用 set_item 和 set_count 会出现 signal 重复调用的问题
	var item = other_slot_ui.get_item()
	var count = other_slot_ui.get_count()
	
	other_slot_ui.change(get_item(), get_count())
	change(item, count)


func can_stack(other_slot_ui:InventorySlotUI):
	if not is_same_type(other_slot_ui):
		return false
	return true

func stack_to(other_slot_ui:InventorySlotUI):
	# self -> other_slot_ui
	other_slot_ui.set_count(other_slot_ui.get_count() + inventory_slot.count)
	clear()

func is_same_type(other_slot_ui:InventorySlotUI):
	if not get_item() or not other_slot_ui.get_item():
		return false
	return inventory_slot.is_same_type(other_slot_ui.inventory_slot)

func get_item() -> BaseItem:
	return inventory_slot.item

func get_count():
	return inventory_slot.count

func set_item(value:BaseItem):
	if value != inventory_slot.item:
		inventory_slot.item = value
		update()
		slot_changed.emit()

func set_count(value:int):
	if value != inventory_slot.count:
		inventory_slot.count = value
		update()
		slot_changed.emit()

func change(item:BaseItem, count:int):
	inventory_slot.change(item, count)
	update()
	slot_changed.emit()

func clear():  
	if inventory_slot.item != null:
		inventory_slot.clear()
		update()
		slot_changed.emit()
	
func update():
	if inventory_slot.item:
		_set_count(inventory_slot.count)
		_set_texture(inventory_slot.item.texture)
		_set_name(inventory_slot.item.name)
	else:
		_set_count(0)
		_set_texture(null)
		_set_name("")

## Utils
func _set_texture(value:Texture2D):
	texture_rect.texture = value

func _set_count(value:int):
	if value <= 0:
		label_count.hide()
	else:
		label_count.show()
	label_count.text = str(value)

func _set_name(value:String):
	if value == "":
		label_name.hide()
	else:
		label_name.show()
	label_name.text = value
