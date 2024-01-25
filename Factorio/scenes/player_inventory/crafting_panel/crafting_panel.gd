extends VBoxContainer

signal slot_pressed(item:BaseItem)

@export var slot_packed_scene:PackedScene
#const CRAFT_ITEM_SLOT_PACKED_SCENE = preload("res://scenes/player_inventory/crafting_panel/craft_item_slot/craft_item_slot.tscn")

var title = "IntermidiateProducts"
var carft_items = []
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var Items = DatatableManager.base_items
	carft_items = [
		[Items.COAL, Items.IRON_ORE],
		[Items.IRON_CHEST, Items.TRANSPORT_BELT_1, Items.INSERTER_1],
		[Items.MINING_DRILL, Items.STONE_FURNACE, Items.ASSEMBLING_MACHINE_1],
	]
	slot_pressed.connect(
		func(item, count):
			Globals.player_inventory.add_item(item, count)
	)
	_initialize()

func _initialize():
	for items in carft_items:
		var hbox_container = HBoxContainer.new()
		add_child(hbox_container)
		for item in items:
			var slot = slot_packed_scene.instantiate()
			hbox_container.add_child(slot)
			var count = 1
			slot.set_item(item, count)
			slot.pressed.connect(func():
				slot_pressed.emit(item, count)
				)
			

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
				
