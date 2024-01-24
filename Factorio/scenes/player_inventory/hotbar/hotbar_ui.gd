extends HBoxContainer

signal slot_pressed(index:int)

@export var SLOT_PACKE_SCENE:PackedScene

func _ready():
	var player_inventory = Globals.player_inventory as PlayerInventory
	player_inventory.hotbar_changed.connect(func(): _update(player_inventory.get_hotbar_slots()))
	player_inventory.invetory_changed.connect(func(): _update(player_inventory.get_hotbar_slots()))
	slot_pressed.connect(
		func(index):
			player_inventory.interact_with_hotbar(index, Globals.button_index)
	)
	_initialize(player_inventory.get_hotbar_slots())
	
### Utils
func _initialize(slots:Array[InventorySlot]):
	# clear
	for slot in get_children():
		remove_child(slot)
		slot.queue_free()
	# add
	for i in slots.size():
		var slot = SLOT_PACKE_SCENE.instantiate()
		add_child(slot)
		slot.pressed.connect(func(): slot_pressed.emit(slot.get_index()))
	# update
	_update(slots)

func _update(slots:Array[InventorySlot]):
	if slots.size() != get_children().size():
		_initialize(slots)
		return
	for index in slots.size():
		var hotbar_slot = get_child(index)
		if not slots[index]:
			hotbar_slot.set_empty()
		else:
			hotbar_slot.set_slot(slots[index])
		









	
