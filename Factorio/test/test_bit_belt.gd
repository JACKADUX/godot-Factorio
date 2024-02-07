extends Control


enum SlotIndex {
	Null,
	SLOT1,  # -> 1
	SLOT2,
	SLOT3,
	SLOT4,  # -> 4
}

var _bits_1 = 0

func _start_work():
	if not (_bits_1 & 1):
		_bits_1 = _bits_1 | 1
	
func _update_work():
	if _bits_1 == 15:  # 1111
		return 
	var stuck = 0
	if _bits_1 & 8:
		stuck = stuck | 8
		if _bits_1 & 4:
			stuck = stuck | 4
			if _bits_1 & 2:
				stuck = stuck | 2
				
	_bits_1 = _bits_1 << 1
	if stuck != 0:
		_bits_1 = _bits_1 | stuck  # 把原先的位加回去
		_bits_1 = _bits_1 & 15     # 只保留前4位
	
func _end_work():
	_bits_1 = _bits_1 & -9  # ~8 8取反

func _process(delta):
	$Label.text = get_bit()

func get_bit():
	var bit = BitHelper.int2bin(_bits_1)
	var left = 4 - len(bit)
	if left > 0:
		bit = "0".repeat(left)+bit
	return bit
	
func _on_button_pressed():
	_start_work()


func _on_button_2_pressed():
	_update_work()


func _on_button_3_pressed():
	_end_work()
