class_name SingleBelt

var _input_belt :SingleBelt

var _slots :Array[int]= []
var _bits = 0  # size 不一定要1格 可以是63格 动态融合

func push_front(id:int):
	pass

func insert(id:int):
	pass

func pop_end():
	pass
	
func remove_at():
	pass

## -------- bit
func _bit_is_empty():
	return _bits == 0
func _bit_is_full():
	return _bits == 15
func _bit_set_1():
	_bits = _bits | 1
func _bit_clear_4():
	_bits = _bits & -9  # ~8 8取反 == -9
func _bit_shift():
	var stuck = 0
	if _bits & 8:
		stuck = stuck | 8
		if _bits & 4:
			stuck = stuck | 4
			if _bits & 2:
				stuck = stuck | 2
	_bits = ((_bits << 1) | stuck) & 15 # 把原先的位加回去 # 只保留前4位
