class_name EGBaseTool extends Node

signal change_to_tool(tool_name:String, temp:bool)

var _eg_editor:EGEditor

var _prev_tool:EGBaseTool

## Utils
func change_tool(tool_name:String):
	if tool_name == name:
		return 
	change_to_tool.emit(tool_name, false)

func is_temp_tool():
	return is_instance_valid(_prev_tool)

func use_temp_tool(tool_name:String):
	if tool_name == name:
		return 
	change_to_tool.emit(tool_name, true)
	
func release_temp_tool():
	if is_temp_tool():
		change_tool(_prev_tool.name)
		_prev_tool = null

func handle_mouse_input(mih:MouseInputHandler):
	if mih.is_just_pressed():
		just_pressed(mih)
	elif mih.is_pressed_and_move():
		pressed_and_move(mih)
	elif mih.is_just_released():
		just_released(mih)
	elif mih.is_hovered():
		hovered(mih)
		
## Override
func _start_use_tool():
	pass

func _end_use_tool():
	pass

func just_pressed(mih:MouseInputHandler):
	pass
	
func pressed_and_move(mih:MouseInputHandler):
	pass
	
func just_released(mih:MouseInputHandler):
	pass

func hovered(mih:MouseInputHandler):
	pass


