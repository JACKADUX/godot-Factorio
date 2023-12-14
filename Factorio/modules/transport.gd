class_name Transport extends RefCounted

var from_storage:Storage
var to_storage:Storage
var count = 1

func trans():
	if not from_storage or not to_storage or from_storage.is_empty() or to_storage.is_full():
		return 
	var res = to_storage.request_feed(from_storage.get_type(), count)
	if not res:
		return 
	to_storage.feed(from_storage.take(res))
	
