extends Node

signal inventory_slot_clicked(inventory, slot)

const GridSize = 32
const GridSizeHalf = GridSize*0.5
const GridSizeVector = Vector2.ONE*GridSize
const GridSizeHalfVector = Vector2.ONE*GridSizeHalf

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				pass

