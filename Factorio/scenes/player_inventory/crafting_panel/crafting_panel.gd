extends VBoxContainer

@export var player_inventory:InventoryUI

const CRAFT_ITEM_SLOT_PACKED_SCENE = preload("res://scenes/player_inventory/crafting_panel/craft_item_slot/craft_item_slot.tscn")

var title = "IntermidiateProducts"
var carft_items = [
	[Items.COAL, Items.IRON_ORE],
	[Items.IRON_CHEST, Items.TRANSPORT_BELT, Items.INSERTER],
	[Items.MINING_DRILL, Items.STONE_FURNACE, Items.ASSEMBING_MACHINE_1],
	]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize()

func _initialize():
	for items in carft_items:
		var hbox_container = HBoxContainer.new()
		add_child(hbox_container)
		for item in items:
			var slot = CRAFT_ITEM_SLOT_PACKED_SCENE.instantiate()
			hbox_container.add_child(slot)
			slot.set_item(item)
			slot.pressed.connect(_on_craft_slot_pressed.bind(slot))
			
func _on_craft_slot_pressed(slot:CraftItemSlot):
	var item := slot.get_item()
	player_inventory.add_item(item, 1)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
				
