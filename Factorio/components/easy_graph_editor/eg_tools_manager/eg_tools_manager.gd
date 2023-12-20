class_name EGToolsManager extends Node

signal tool_changed

@export var eg_elements_manager:EGElementsManager
@export var mouse_input_handler:MouseInputHandler
@export var eg_camera:EGCamera

@onready var eg_editor:EGEditor = get_parent()

var current_tool:EGBaseTool
var tools := {}

## Virtual
func _ready():
	mouse_input_handler.mouse_state_changed.connect(handle_mouse_input)
	
	for tool in get_children():
		if not tool is EGBaseTool:
			continue
		tools[get_tool_name(tool)] = tool
		tool.change_to_tool.connect(_on_change_to_tool.bind(tool))
		tool._eg_editor = eg_editor
		
	change_tool_to(get_child(0))
	
	
## Utils
func handle_mouse_input():
	if not current_tool:
		return 
	current_tool.handle_mouse_input(mouse_input_handler)
	
	 
func get_tool_name(tool:EGBaseTool) -> String:
	return tool.name.to_lower()
	
func get_tool_by(tool_name:String):
	return tools.get(tool_name.to_lower())

func set_current_tool(tool:EGBaseTool) -> bool:
	if current_tool == tool:
		return false
	if current_tool:
		print("end tool: ", current_tool.name)
		current_tool._end_use_tool()
	if tool:
		print("start tool: ", tool.name)
		tool._start_use_tool()
	current_tool = tool
	return true

func change_tool_to(tool:EGBaseTool):
	if set_current_tool(tool):
		tool_changed.emit()


## OnSignal
func _on_change_to_tool(tool_name:String, temp:bool, tool:EGBaseTool):
	if tool_name != get_tool_name(current_tool) and tool == current_tool:
		var new_tool = get_tool_by(tool_name)
		if temp:
			new_tool._prev_tool = current_tool
		change_tool_to(new_tool)


