extends Node2D


@onready var mining_machine = %MiningMachine


func _ready() -> void:
	var coal_mines = StorageCollection.new()
	coal_mines.append_storage(Storage.create(Enums.Items.Coal, 1000))
	coal_mines.append_storage(Storage.create(Enums.Items.Coal, 1000))
	coal_mines.append_storage(Storage.create(Enums.Items.Coal, 1000))
	
	for coal_mine in coal_mines.get_storages():
		mining_machine.add_input(coal_mine)
	mining_machine.assign_inputs()
	
	
	
func _process(delta: float) -> void:
	mining_machine.update()


func _on_button_pressed():
	pass
