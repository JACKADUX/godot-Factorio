class_name Inventory
# https://juejin.cn/post/6963550825499066398
signal inventory_changed

var _size :int = 0
var _bits :int = 0
var _slots :Array = []

# slot -> [id, count]

func _init(inventory_size:int=0) :
	_size = clamp(inventory_size, 0, 63)  #??
	
func size():
	return _size

func get_slots():
	return _slots

func new_slot(id:int, count:int) -> Array[int]:
	return [id, count]

func has_slot(index:int) -> bool:
	return _has_one(index+1)
	
func get_slot(index:int) -> Array[int]:
	assert( 0 <= index and index < _size)	
	index+=1
	if not _has_one(index):
		return []
	var r_index = _get_slot_index(index)
	return _slots[r_index]
	
func override_slot(index:int, id:int, count:int):
	assert( 0 <= index and index < _size)
	if count == 0:
		remove_slot(index)
		return 
	index+=1
	var slot := new_slot(id, count)
	var r_index = _get_slot_index(index)
	if _has_one(index):
		_slots[r_index] = slot
	else:
		if r_index + 1 > _slots.size():
			_slots.append(slot)
		else:
			_slots.insert(r_index+1, slot)
	_bits = _set_one(index)
	inventory_changed.emit()

func remove_slot(index:int):
	assert( 0 <= index and index < _size)
	index += 1
	if not _has_one(index):
		return
	var r_index = _get_slot_index(index)
	_slots.remove_at(r_index)
	_bits = _set_zero(index)
	inventory_changed.emit()

func find_slots(id:int):
	return _slots.filter(func(slot): return slot[0] == id)

func input(id:int, count:int):
	# 无脑塞进来, 返回无法塞进inventory的数量
	var max_count = DatatableManager.get_item_max_count(id)
	var counter_index = 0
	for i in _size:
		if count == 0:
			break
		if _has_one(i+1):
			# 有物体
			var slot = _slots[counter_index]
			var slot_id = slot[0]
			var amount = slot[1]
			if slot_id == id:
				var space_left = max_count-amount
				if count <= space_left:
					_set_slot_amount(counter_index, amount+count)
					count = 0
				else:
					_set_slot_amount(counter_index, max_count)
					count -= space_left
			counter_index += 1
		else:
			# 空
			if max_count <= count:
				override_slot(i, id, max_count)
				count -= max_count
			else:
				override_slot(i, id, count)
				count = 0
	return count

func get_amount_data() -> Dictionary:
	""" { id : amount } """
	var data := {}
	for slot in _slots:
		var id :int = slot[0]
		if not data.has(id):
			data[id] = 0
		data[id] += slot[1]
	return data


	
	
## Utils
func _sort(sort_callable:Callable):
	# FIXME: 循环引用
	# sort_callable = func(a,b): return a < b
	#var amount_data = get_amount_data()
	#var order_items = amount_data.keys()
	#order_items.sort_custom(sort_callable)
	#_bits = 0
	#_slots = []
	#for i in order_items.size():
		#var id:int = order_items[i]
		#var amount = amount_data[id]
		#while true:
			#var left = input(id, amount)
			#if not left:
				#break
			#amount = left
	pass	

func _set_slot_amount(real_index:int, amount:int):
	## 暂时不使用，需要 real_index进行内部转换再作为开放接口 否则容易出错
	assert( 0 <= real_index and real_index < _slots.size())
	if amount <= 0:
		# clear
		var index = _get_slot_bit_index(real_index)
		remove_slot(index)
	else:
		_slots[real_index][1] = amount
		inventory_changed.emit()

## Statics
static func transfer(from_inventroy:Inventory, id:int, request_amount:int, to_inventory:Inventory):
	## 当 request_amount < 0 时， request_amount 就等于第一个 id slot 的 amount
	if request_amount == 0:
		return 
	var slots = from_inventroy.find_slots(id)
	if not slots:
		return 
	if request_amount < 0:
		request_amount = slots[0][1]  # slot [id, amount]

	for slot in slots:
		if request_amount == 0:
			break
		var amount = slot[1]
		var transfer_amount = request_amount if request_amount < amount else amount
		var left = to_inventory.input(id, transfer_amount)
		var real_transfer_amount = transfer_amount-left
		request_amount -= real_transfer_amount 
		
		var index = from_inventroy.get_slots().find(slot)
		from_inventroy._set_slot_amount(index, amount-real_transfer_amount)
	
	return request_amount  # 多出实际存储量的部分



# ------------------ bit : start from 1
func _has_one(bit_index:int):
	return (_bits & 1 << (bit_index - 1)) > 0

func _set_one(bit_index:int):
	return _bits | 1 << (bit_index - 1)
	
func _set_zero(bit_index:int):
	return _bits & ~( 1 << (bit_index - 1))

func _get_slot_index(bit_index:int):
	var count = 0
	var x = _bits
	x = x & ((1 << bit_index)-1)  # 保留前index 位
	if x == 0:
		return -1
	while true:
		x = x & (x-1)
		if x == 0:
			break
		count += 1 
	return count
	
func _get_slot_bit_index(real_index:int):
	# 通过 slot 的 real_index 计算在 _bits 中的 bit_index (从0开始
	# 10100101  -> real_index == 2
	# --1-----  -> return 5
	var count = 0
	var x = _bits
	while true:
		if count == real_index:
			break
		x = x&(x-1)
		if x == 0:
			break
		count += 1 
	return log(x & (-x)) / log(2)
