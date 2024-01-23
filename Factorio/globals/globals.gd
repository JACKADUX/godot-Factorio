extends Node

signal inventory_slot_clicked(inventory, slot)

const GridSize = 32
const GridSizeHalf = GridSize*0.5
const GridSizeVector = Vector2.ONE*GridSize
const GridSizeHalfVector = Vector2.ONE*GridSizeHalf

var button_index:MouseButton

var main_camera:Camera2D


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		# NOTE: 必须要这样否则 Button 无法获取按键
		button_index = event.button_index
