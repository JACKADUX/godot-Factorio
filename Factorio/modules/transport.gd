class_name Transport extends RefCounted

var from_storage:Storage
var to_storage:Storage
var count:int

func transport() -> bool:
	if not can_transport():
		return false
	to_storage.feed(from_storage.take(to_storage.request_feed(count)))
	return true
	
func can_transport() -> bool:
	if not from_storage or not to_storage or from_storage.is_empty() or to_storage.is_full():
		return false
	if not to_storage.is_same_type(from_storage):
		return false
	var token = from_storage.request_take(to_storage.request_feed(count))
	if token <= 0:
		return false
	return true

static func create(from:Storage, to:Storage, count:int):
	var trs = Transport.new()
	trs.from_storage = from
	trs.to_storage = to
	trs.count = count
	return trs
