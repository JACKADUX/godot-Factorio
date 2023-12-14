class_name Converter extends RefCounted

signal start_convert

var inputs :Array[Storage] = []
var outputs :Array[Storage] = []

var formula := Formula.new()

func convert():
	if not formula.apply_formula(inputs):
		return 
	start_convert.emit()
	
	outputs = formula.get_outputs()
