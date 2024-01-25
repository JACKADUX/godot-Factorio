class_name EGCameraTool extends EGBaseTool

var _pressed := false
var eg_camera :EGCamera:
	get:
		return _eg_editor.eg_camera

func _start_use_tool():
	super()
	_pressed = false
	
func _end_use_tool():
	super()
	_pressed = false
	
## Virtual
func handle_mouse_input(mih:MouseInputHandler):
	if mih.button_index == MOUSE_BUTTON_MIDDLE or mih.button_index == MOUSE_BUTTON_LEFT:
		super(mih)
		
func just_pressed(mih:MouseInputHandler):
	_pressed = true
	
func pressed_and_move(mih:MouseInputHandler):
	eg_camera.set_world_offset(mih.end_position -mih.start_position)
	
func just_released(mih:MouseInputHandler):
	_pressed = false

	
## Interface
func wheel_scrolled(value):
	if _pressed:
		return 
	if Input.is_key_pressed(KEY_CTRL):
		if value > 0:
			eg_camera.set_world_offset(Vector2(0, -100))
		else:
			eg_camera.set_world_offset(Vector2(0, 100))
		
	elif Input.is_key_pressed(KEY_SHIFT):
		if value > 0:
			eg_camera.set_world_offset(Vector2(-100, 0))
		else:
			eg_camera.set_world_offset(Vector2(100, 0))
	else:
		if value > 0:
			eg_camera.zoom_in()
		else:
			eg_camera.zoom_out()
