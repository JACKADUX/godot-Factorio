extends VBoxContainer

signal slot_pressed(id, count)

@export var slot_packed_scene:PackedScene
#const CRAFT_ITEM_SLOT_PACKED_SCENE = preload("res://scenes/player_inventory/crafting_panel/craft_item_slot/craft_item_slot.tscn")

var title = "IntermidiateProducts"
var carft_items = []
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.temp_craft_panel = self
	slot_pressed.connect(Globals.player_inventory.input)
	_initialize()
	
func _feed_data():
	var Items = DatatableManager.item_datas
	carft_items = [
		[Items.COAL, Items.IRON_ORE],
		[Items.IRON_CHEST, Items.TRANSPORT_BELT_1, Items.INSERTER_1],
		[Items.MINING_DRILL, Items.STONE_FURNACE, Items.ASSEMBLING_MACHINE_1],
	]
	_initialize()

func _initialize():
	for items in carft_items:
		var hbox_container = HBoxContainer.new()
		add_child(hbox_container)
		for item_data in items:
			var slot:CraftItemSlot = slot_packed_scene.instantiate()
			hbox_container.add_child(slot)
			var count = 1
			slot.set_item(item_data.id, count)
			slot.pressed.connect(func():
				slot_pressed.emit(item_data.id, count)
				)
			

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
				
