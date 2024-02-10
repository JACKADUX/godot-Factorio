class_name SingleBelt

var _slots :Array[int]= []
var _bits = 0  # size 不一定要1格 可以是63格 动态融合
var _size = 5

func has_input_space():
	# _bit_get_stuck != 11110
	return not _bit_has_1() and not _bit_is_full()

func push_front(id:int):
	if has_input_space():
		_bit_set_1()
		_slots.push_front(id)

func insert(id:int):
	pass

func pop_end():
	if _bit_has_end():
		_bit_clear_end()
		return _slots.pop_back()
	
func remove_at():
	pass
	
func shift():
	if _bit_is_empty() or _bit_is_full():
		return 
	_bit_shift()
	
## -------- bit
func _get_indexs():
	var inds = []
	for i in _size:
		if _bits & int(pow(2, i)):
			inds.append(i)
	return inds
	
func _bit_is_empty():
	return _bits == 0
	
func _bit_is_full(): # -> 11110
	return _bits == pow(2, _size)-2

func _bit_set_1():
	_bits = _bits | 1
func _bit_has_1():
	return (_bits & 1) != 0
	
func _bit_clear_end():
	_bits = _bits & ~int(pow(2, _size-1))  # ~16 16取反 == -17 
func _bit_has_end():
	return (_bits & int(pow(2, _size-1))) != 0

func _bit_get_stuck():
	var stuck = 0
	for i in _size:
		var j = _size-i
		if j == 1:
			# 1 不需要
			break
		var last_bit = int(pow(2, j-1))
		if _bits & last_bit:
			stuck = stuck | last_bit
		else:
			break
	return stuck
	#if _bits & 8:
		#stuck = stuck | 8
		#if _bits & 4:
			#stuck = stuck | 4
			#if _bits & 2:
				#stuck = stuck | 2

	
func _bit_shift():
	_bits = ((_bits << 1) | _bit_get_stuck()) & int(pow(2, _size)-1) # 把原先的位加回去 # 只保留前5位
