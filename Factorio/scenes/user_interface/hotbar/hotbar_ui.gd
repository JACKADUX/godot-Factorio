extends HBoxContainer

signal slot_pressed(index:int)

@export var SLOT_PACKE_SCENE:PackedScene

### Utils
func _initialize(inventory:Inventory):
	# clear
	for slot in get_children():
		remove_child(slot)
		slot.queue_free()
	# add
	for i in inventory.size():
		var slot = SLOT_PACKE_SCENE.instantiate()
		add_child(slot)
		slot.pressed.connect(func(): slot_pressed.emit(i))
	# update
	_update(inventory)

func _update(inventory:Inventory):
	if inventory.size() != get_children().size():
		_initialize(inventory)
		return
	for index in inventory.size():
		var hotbar_slot = get_child(index)
		var slot := inventory.get_slot(index)
		if not slot:
			hotbar_slot.set_empty()
		else:
			hotbar_slot.set_slot(slot)
		









	
