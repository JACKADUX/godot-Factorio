class_name EGElementCollection extends Node

signal element_added(element)
signal element_removed(element)
signal collection_changed

func remove_all_elements():
	for element in get_elements():
		remove_child(element)
		element_removed.emit(element)
	collection_changed.emit()

func add_elements(value:Array):
	for element in value:
		add_child(element)
		element_added.emit(element)
	collection_changed.emit()

func add_element(element:EGBaseElement):
	add_child(element)
	element_added.emit()
	collection_changed.emit()
	
func remove_element(element:EGBaseElement):
	remove_child(element)
	element_removed.emit(element)
	collection_changed.emit()


func get_elements():
	return get_children()

func get_reversed_elements():
	var children = get_children()
	children.reverse()
	return children

func get_elements_in_mouse_inside_group():
	# 这个组会自动根据elment的可见状态添加或者删除element
	# 详细查看 EGBaseElement 对象
	return get_tree().get_nodes_in_group(EGBaseElement.GroupNameMouseInside)

func get_elements_in_visable_group():
	# 这个组会自动根据elment的可见状态添加或者删除element
	# 详细查看 EGBaseElement 对象
	return get_tree().get_nodes_in_group(EGBaseElement.GroupNameVisable)

