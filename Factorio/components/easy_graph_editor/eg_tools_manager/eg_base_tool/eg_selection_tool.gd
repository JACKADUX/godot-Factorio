class_name EGSelectionTool extends EGBaseTool

var eg_elements_manager:EGElementsManager:
	get:
		return _eg_editor.eg_elements_manager

@onready var eg_selection_area = $EGSelectionArea
@onready var eg_transform_frame = $"../EGTransformTool/EGTransformFrame"

var _select :Callable
var _start_selection_area := false
var _inside_eg_transform_frame

## Virtual
func just_pressed(mih:MouseInputHandler):
	if mih.button_index == MOUSE_BUTTON_LEFT:
		var selectable = eg_elements_manager.get_selectable_element()
		_inside_eg_transform_frame = eg_transform_frame.has_point(mih.start_position)
		_select = callable_select(selectable)
		
		if not selectable:
			if not _inside_eg_transform_frame:
				_select.call()
				_start_selection_area = true
			return 
		if Input.is_key_pressed(KEY_CTRL):
			_select.call()
			_start_selection_area = true
			return 
		if selectable and not eg_elements_manager.is_selected(selectable):
			_select.call()
			
		
func pressed_and_move(mih:MouseInputHandler):
	if mih.button_index == MOUSE_BUTTON_LEFT:
		if _start_selection_area:
			eg_selection_area.show()
			eg_selection_area.set_rect(Rect2(mih.start_position, mih.end_position-mih.start_position))
		elif mih.is_dragged():
			use_temp_tool("EGTransformTool")
						
		
func just_released(mih:MouseInputHandler):
	if mih.button_index == MOUSE_BUTTON_LEFT:
		if _start_selection_area:
			eg_selection_area.hide()
			_start_selection_area = false
		elif not mih.is_dragged():
			_select.call()
			_select = Callable()
			
			
func hovered(mih:MouseInputHandler):
	pass

## Utils
func callable_select(element:EGBaseElement) -> Callable:
	var em = eg_elements_manager
	var is_selected = em.is_selected(element)	if element else false
	var shift = Input.is_key_pressed(KEY_SHIFT)
	
	var _func_select = Callable()
	if element:
		if shift:
			if not is_selected:
				_func_select = func(): em.select(element)  # select
			else:
				_func_select = func(): em.deselect(element)  # deselect
		else:
			_func_select = func(): # single_select
				em.deselect_all()  
				em.select(element)
	else:
		if not shift:
			_func_select = func(): em.deselect_all()	# deselect_all
		else:
			_func_select = func(): pass
	return _func_select




















	
