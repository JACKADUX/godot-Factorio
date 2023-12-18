extends Node2D
const MINING_MACHINE = preload("res://modules/entities/mining_machine.tscn")
func _ready():
	for i in 5000:
		var mm = MINING_MACHINE.instantiate()
		add_child(mm)
		
