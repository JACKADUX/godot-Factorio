class_name Transport extends RefCounted

var from_storage:Storage
var to_storage:Storage

func trans(count:int) -> bool:
	if not from_storage or not to_storage or from_storage.is_empty() or to_storage.is_full():
		return false
	var token = from_storage.take(to_storage.request_feed(count))
	if token <= 0:
		return false
	if to_storage.is_empty() and not to_storage.is_type_fixed():
		to_storage.set_type(from_storage.get_type())
	if to_storage.is_same_type(from_storage):
		to_storage.feed(token)
		return true
	return false
