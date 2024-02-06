extends Control

@onready var line_edit_1 = %LineEdit
@onready var line_edit_2 = %LineEdit2
@onready var button = %Button
@onready var button_2 = %Button2
@onready var line_edit_or = %LineEditOR
@onready var line_edit_and = %LineEditAND

@onready var line_edit_test = %LineEditTest

func test():
	var a = [1,2,3,4,5]
	a.insert(1,10)
	print(a)
	
	#
	#var t = Time.get_ticks_msec()
	#var v = 2**60-1
	#print(int2bin(v))
	#for i in range(10000):
		#get_index_from(v, 30)
	#print(Time.get_ticks_msec()-t)
	#for i in range(10000):
		#get_index_from_simp(v, 30)
	#print(Time.get_ticks_msec()-t)
	
func _on_line_edit_test_text_submitted(new_text):
	var value = int(line_edit_1.text)
	var x = value
	var count = 0
	var index = int(line_edit_test.text)
	print(int2bin(value))
	print(get_real_index(value, index))
	#while true:
		#print(x, " - ", count, " - ", int2bin(x))
		#x = x&(x-1)
		#if x == 0:
			#break
		#count += 1 
	#print(get_index_from_simp(value, index))
	#print(get_index_from(value, index))
	
	#print(get_real_index(value, int(line_edit_test.text)))


func logWithBase(value, base): 
	return log(value) / log(base)


func get_index_from_simp(number:int, real_index:int):
	# 是 get_index_from 的 三倍 （10000）
	var total = -1
	var count = -1
	var x = number
	while true:
		if count == real_index:
			break
		if x == 0:
			break
		if (x & 1):
			count += 1
		x = x >> 1
		total += 1
	return total

func get_index_from(number:int, real_index:int):
	var count = 0
	var x = number
	while true:
		if count == real_index:
			break
		x = x&(x-1)
		if x == 0:
			break
		count += 1 
	return log(x & (-x)) / log(2)


func get_real_index(number:int, index:int):
	var count = 0
	number = number & ((1 << index)-1)
	if number == 0:
		return -1
	while true:
		#print(number, " - ", count, " - ", int2bin(number))
		number = number & (number-1)
		if number == 0:
			break
		count += 1 
	return count
		
func int2bin(value):
	var out = ""
	while (value > 0):
		out = str(value & 1) + out
		value = (value >> 1)
	return out

func _on_button_pressed():
	var value = clamp(int(line_edit_1.text) << 1, 0, 15)
	line_edit_1.set_text(str(value))
	_on_line_edit_text_changed(line_edit_1.text)
	
func _on_button_2_pressed():
	var value = clamp(int(line_edit_1.text) >> 1, 0, 15)
	line_edit_1.set_text(str(value))
	_on_line_edit_text_changed(line_edit_1.text)
	

func _on_line_edit_text_changed(new_text:String):
	#line_edit_1.text = new_text
	line_edit_2.text = int2bin(int(new_text))

func _on_line_edit_2_text_changed(new_text):
	#line_edit_2.text = new_text
	line_edit_1.text = str(new_text.bin_to_int())


func _on_line_edit_or_text_submitted(new_text):
	var value = clamp(int(line_edit_1.text)| int(new_text), 0, 15)
	line_edit_1.set_text(str(value))
	_on_line_edit_text_changed(line_edit_1.text)


func _on_line_edit_and_text_submitted(new_text):
	var value = clamp(int(line_edit_1.text) & int(new_text), 0, 15)
	line_edit_1.set_text(str(value))
	_on_line_edit_text_changed(line_edit_1.text)


func _on_line_edit_has_item_text_submitted(new_text):
	var value = int(line_edit_1.text)
	var index = int(new_text)
	$Label3.text = str(has_item(value, index))
	
func has_item(number:int, index:int):
	return (number & 1 << (index - 1)) > 0

func set_item(number:int, index:int):
	return number | 1 << (index - 1)
	
func get_item(number:int, index:int):
	return number & ~( 1 << (index - 1))

func _on_line_edit_set_item_text_submitted(new_text):
	var value = int(line_edit_1.text)
	var index = int(new_text)
	_on_line_edit_text_changed(str(set_item(value, index)))
	_on_line_edit_2_text_changed(line_edit_2.text)
	
func _on_line_edit_get_item_text_submitted(new_text):
	var value = int(line_edit_1.text)
	var index = int(new_text)
	_on_line_edit_text_changed(str(get_item(value, index)))
	_on_line_edit_2_text_changed(line_edit_2.text)
	


func _on_button_3_pressed():
	test()


