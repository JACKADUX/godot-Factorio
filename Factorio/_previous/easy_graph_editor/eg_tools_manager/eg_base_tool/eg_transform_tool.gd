class_name EGTransformTool extends EGBaseTool

var eg_elements_manager:EGElementsManager:
	get:
		return _eg_editor.eg_elements_manager

@onready var eg_transform_frame = $EGTransformFrame


var _initialized := false
var _selection := []

var _pressed := false


func _process(delta):
	if not _initialized:
		_initialized = true
		eg_elements_manager.selection_changed.connect(_on_selection_changed)
## Virtual
func _start_use_tool():
	super()
	_pressed = false
	
func just_pressed(mih:MouseInputHandler):
	if mih.button_index != MOUSE_BUTTON_LEFT:
		return 
	_pressed = true
	for element in _selection:
		element.transform_component.start_trans()
	
func pressed_and_move(mih:MouseInputHandler):
	if mih.button_index != MOUSE_BUTTON_LEFT:
		return 
	if not _pressed:
		just_pressed(mih)
	var offset = mih.end_position - mih.start_position
	for element in _selection:
		element.global_position = element.transform_component.get_start_position() + offset
	update_frame()
	
		
func just_released(mih:MouseInputHandler):
	if mih.button_index != MOUSE_BUTTON_LEFT:
		return 
	_pressed = false
	for element in _selection:
		element.transform_component.end_trans()
	
	release_temp_tool()
	
func hovered(mih:MouseInputHandler):
	pass

## Utils
func update_frame():
	if not _selection:
		eg_transform_frame.hide()
		return 
	eg_transform_frame.show()
	var rect :Rect2
	for element:EGBaseElement in _selection:
		var area = element.get_area()
		area.position += element.global_position
		if not rect:
			rect = area
			continue
		rect = rect.merge(area)
	eg_transform_frame.set_rect(rect)

## OnSignals
func _on_selection_changed():
	_selection = eg_elements_manager.get_selected_elements()
	update_frame()
