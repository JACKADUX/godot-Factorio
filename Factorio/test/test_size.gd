extends Node2D


## refcounted 对象只有变量会占用空间
class TestObject extends RefCounted:
	
	signal testsignal
	signal testsignal2
	signal testsignal3
	signal testsignal4
	
	var id :int =1003
	var amount:int=64
	
	func _test():
		print(123)
		var a = 1
	func _test2():
		print(123)
		var a = 1
	func _test3():
		print(123)
		var a = 1
		
func _ready():
	var number = 10
	var memory_before = OS.get_static_memory_usage()
	var a = []
	for i in range(number):
		a.append(TestObject.new())
	var memory_used = OS.get_static_memory_usage() - memory_before
	print("refcounted:", memory_used)
	
	var memory_before2 = OS.get_static_memory_usage()
	var b = []
	for i in range(number):
		b.append([1003, 64])
	var memory_used2 = OS.get_static_memory_usage() - memory_before2
	print("Array: ",memory_used2)

	var memory_before3 = OS.get_static_memory_usage()
	var c = {}
	for i in range(number):
		c[i] = [1003, 64]
	var memory_used3 = OS.get_static_memory_usage() - memory_before3
	print("Diction: ",memory_used3)
