extends CanvasLayer

@onready var center_container_2 = $Control/CenterContainer2

@onready var player_inventory_ui := %PlayerInventoryUI as InventoryUI
@onready var hand_slot := %HandSlot as InventorySlotUI
@onready var crafting_panel := %CraftingPanel
@onready var hotbar := %Hotbar


func _ready():
	var player_inventory = Globals.player_inventory
	player_inventory.invetory_changed.connect(_on_player_invetory_changed.bind(player_inventory))
	player_inventory.hotbar_changed.connect(_on_hotbar_changed.bind(player_inventory))
	player_inventory.hand_slot_changed.connect(_on_hand_slot_changed.bind(player_inventory))
	## player_inventory_ui
	player_inventory_ui.slot_pressed.connect(
		func(index):
			match Globals.button_index:
				MOUSE_BUTTON_LEFT:
					player_inventory.interact_with_hand_slot(player_inventory, index)
	)
	player_inventory_ui._initialize(player_inventory)
	## hotbar
	hotbar.slot_pressed.connect(
		func(index):
			match Globals.button_index:
				MOUSE_BUTTON_LEFT: 
					player_inventory.interact_with_hotbar(index)
				MOUSE_BUTTON_RIGHT: 
					pass
				MOUSE_BUTTON_MIDDLE:
					player_inventory._remove_hotbar_item(index)
	)
	hotbar._initialize(player_inventory.hotbar)
	## hand_slot
	hand_slot._initialize()
	
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			pass
			if event.keycode == KEY_E:
				center_container_2.visible = not center_container_2.visible

## OnSignal
func _on_player_invetory_changed(player_inventory:PlayerInventory):
	player_inventory._auto_arrange()
	player_inventory_ui._update(player_inventory)
	hotbar._update(player_inventory.get_hotbar())

func _on_hotbar_changed(player_inventory:PlayerInventory):
	hotbar._update(player_inventory.get_hotbar())

func _on_hand_slot_changed(player_inventory:PlayerInventory):
	hand_slot._update(player_inventory.hand_slot)
	













