class_name CustomTimer

signal timeout

var _wait_time:float = 1
var _stoped:= true
var _time:float = 0
var one_time:=false

var time_left:float:
	get: return _wait_time -_time

func _init(wait_time:float=1):
	_wait_time = wait_time
	_time = 0

func start(time_sec:float=-1):
	_time = 0
	if time_sec > 0:
		_wait_time = time_sec
		_stoped = false
	elif time_sec == -1:
		_stoped = false

func stop():
	_stoped = true
	
func is_stoped():
	return _stoped

func update(delta:float):
	if _stoped:
		return 
	_time += delta
	if _time >= _wait_time:
		if one_time:
			## NOTE: 这个时机很重要！需要留意顺序
			stop()
		_time -= _wait_time
		timeout.emit()
		
	
