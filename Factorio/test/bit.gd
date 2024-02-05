extends Control

@onready var line_edit_1 = %LineEdit
@onready var line_edit_2 = %LineEdit2
@onready var button = %Button
@onready var button_2 = %Button2
@onready var line_edit_or = %LineEditOR
@onready var line_edit_and = %LineEditAND



func int2bin(value):
	var out = ""
	while (value > 0):
		out = str(value & 1) + out
		value = (value >> 1)
	match len(out):
		1 : return "000"+out
		2 : return "00"+out
		3 : return "0"+out
		
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
	
