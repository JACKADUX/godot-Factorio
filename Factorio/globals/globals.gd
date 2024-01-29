extends Node

const GridSize = 32
const GridSizeHalf = GridSize*0.5
const GridSizeVector = Vector2.ONE*GridSize
const GridSizeHalfVector = Vector2.ONE*GridSizeHalf

const group_entity := "entity"

var button_index:MouseButton

var main_camera:Camera2D

var hotbar := Hotbar.new(10)
var player_inventory := PlayerInventory.new(64)
var hand_slot := HandSlot.new()

var temp_craft_panel 
var temp_entity_manager

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		# NOTE: 必须要这样否则 Button 无法获取按键
		button_index = event.button_index


