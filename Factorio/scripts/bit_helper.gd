class_name BitHelper

static func has_one(number:int, index:int):
	return (number & 1 << (index - 1)) > 0

static func set_one(number:int, index:int):
	return number | 1 << (index - 1)

static func set_zero(number:int, index:int):
	return number & ~( 1 << (index - 1))

static func get_real_index(number:int, index:int):
	assert(has_one(number, index))
	var count = 0
	number = number & ((1 << index)-1)  # 保留前index 位
	while true:
		number = number & (number-1)
		if number == 0:
			break
		count += 1 
	return count

static func int2bin(value):
	var out = ""
	while (value > 0):
		out = str(value & 1) + out
		value = (value >> 1)
	return out
