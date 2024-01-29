extends CanvasLayer

@onready var center_container_2 = $Control/CenterContainer2

@onready var player_inventory_ui := %PlayerInventoryUI as InventoryUI
@onready var hand_slot_ui = %HandSlotUI as InventorySlotUI
@onready var crafting_panel := %CraftingPanel
@onready var hotbar_ui = %HotbarUI


func _ready():
	var player_inventory = Globals.player_inventory
	Globals.player_inventory.invetory_changed.connect(_on_player_invetory_changed.bind(player_inventory))
	
	## player_inventory_ui
	player_inventory_ui.slot_pressed.connect(
		func(index):
			match Globals.button_index:
				MOUSE_BUTTON_LEFT:
					Globals.hand_slot.interact_with_hand_slot(player_inventory, index)
	)
	## hand_slot
	var hand_slot = Globals.hand_slot
	hand_slot.hand_slot_changed.connect(_on_hand_slot_changed)
	
	
	## hotbar
	var hotbar = Globals.hotbar
	hotbar.hotbar_changed.connect(_on_hotbar_changed)
	hotbar_ui.slot_pressed.connect(
		func(index):
			match Globals.button_index:
				MOUSE_BUTTON_LEFT: 
					hotbar.interact_with_hotbar(index, hand_slot, player_inventory)
				MOUSE_BUTTON_RIGHT: 
					pass
				MOUSE_BUTTON_MIDDLE:
					hotbar.remove_hotbar_item(index)
	)

	## initialize
	player_inventory_ui._initialize(player_inventory)
	hotbar_ui._initialize(hotbar)
	hand_slot_ui._initialize(hand_slot)
	
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			pass
			if event.keycode == KEY_E:
				center_container_2.visible = not center_container_2.visible

## OnSignal
func _on_player_invetory_changed(player_inventory:PlayerInventory):
	player_inventory_ui._update(player_inventory)
	_on_hotbar_changed()

func _on_hotbar_changed():
	Globals.hotbar.update_hotbar(Globals.player_inventory)
	hotbar_ui._update(Globals.hotbar)

func _on_hand_slot_changed():
	hand_slot_ui._update(Globals.hand_slot)
	













