class_name EGEditor extends Node2D

@onready var mouse_input_handler := %MouseInputHandler as MouseInputHandler
@onready var eg_camera := %EGCamera as EGCamera
@onready var eg_grid := %EGGrid as EGGrid
@onready var eg_elements_manager := %EGElementsManager as EGElementsManager
@onready var eg_tools_manager := %EGToolsManager as EGToolsManager

@onready var background := %Background as EGRect


## Virtual
func _ready():
	eg_camera.view_zoom_changed.connect(_on_view_zoom_changed)
	eg_camera.view_changed.connect(_on_view_changed)
	mouse_input_handler.wheel_scrolled.connect(handle_wheel_scrolled)
	background.set_rect(eg_camera.get_view_rect())

func _unhandled_input(event:InputEvent):
	camera_control(event)
	mouse_input_handler.handled_input(event)

## Utils
func handle_wheel_scrolled(value):
	eg_tools_manager.get_tool_by("EGCameraTool").wheel_scrolled(value)

func camera_control(event):
	var cond1 = event is InputEventKey and event.keycode == KEY_SPACE
	var cond2 = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE
	if not cond1 and not cond2:
		return 
		
	if event.is_pressed():
		eg_tools_manager.current_tool.use_temp_tool("EGCameraTool")
	elif not event.is_pressed():
		eg_tools_manager.current_tool.release_temp_tool()
		
## OnSignals
func _on_view_zoom_changed():
	# 保证不同尺度下拖拽的最小距离不会变
	mouse_input_handler.drag_start_threshold_distance = 4/eg_camera.zoom.x

func _on_view_changed():
	background.set_rect(eg_camera.get_view_rect())
