class_name InventorySlotUI extends Button

@onready var texture_rect = %TextureRect
@onready var label_count = %LabelCount
@onready var label_name = %LabelName

var inventory_slot:InventorySlot

func _ready():
	update()
	
## Interface
func can_exchange(other_slot_ui:InventorySlotUI):
	return true

func exchange(other_slot_ui:InventorySlotUI):
	var _temp = inventory_slot
	set_inventory_slot(other_slot_ui.inventory_slot)
	other_slot_ui.set_inventory_slot(_temp)

func can_stack(other_slot_ui:InventorySlotUI):
	if not other_slot_ui.inventory_slot or not inventory_slot:
		return false
	if not inventory_slot.is_same_type(other_slot_ui.inventory_slot):
		return false
	return true

func stack_to(other_slot_ui:InventorySlotUI):
	# self -> other_slot_ui
	other_slot_ui.change_count(other_slot_ui.inventory_slot.count + inventory_slot.count)
	clear()

func set_inventory_slot(value:InventorySlot):
	inventory_slot = value
	update()

func change_count(value:int):
	inventory_slot.count = value
	update()

func clear():
	inventory_slot = null
	update()
	
func update():
	if inventory_slot and inventory_slot.item:
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
