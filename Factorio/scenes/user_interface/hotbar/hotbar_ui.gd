extends HBoxContainer

signal slot_pressed(index:int)

@export var SLOT_PACKE_SCENE:PackedScene


	
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
		var slot :InventorySlot = slots[index]
		if not slot:
			hotbar_slot.set_empty()
		else:
			hotbar_slot.set_slot(slot)
		









	
