extends CanvasLayer

@onready var root = $Control/Root


@onready var player_inventory_ui := %PlayerInventoryUI as InventoryUI
@onready var hand_slot_ui = %HandSlotUI as InventorySlotUI
@onready var crafting_panel := %CraftingPanel
@onready var hotbar_ui = %HotbarUI


@onready var main_container = %MainContainer
@onready var player_inventory_container = %PlayerInventoryContainer
@onready var craft_container = %CraftContainer
@onready var chest_inventory_container = %ChestInventoryContainer
@onready var chest_inventory_ui = %ChestInventoryUI
var _prev_chest_inventory:Inventory


func _ready():
	_init_playerui()
	

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			pass
			if event.keycode == KEY_E:
				root.visible = not root.visible
				_show_craft()

## Utils
func _init_playerui():
	var player_inventory = Globals.player_inventory
	Globals.player_inventory.invetory_changed.connect(_on_player_invetory_changed.bind(player_inventory))
	
	## player_inventory_ui
	player_inventory_ui.slot_pressed.connect(
		Globals.hand_slot.handle_input_click_event.bind(player_inventory)
	)
	## hand_slot
	var hand_slot = Globals.hand_slot
	hand_slot.slot_changed.connect(_on_hand_slot_changed)
	
	
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

func _hide_all():
	for child in main_container.get_children():
		child.hide()
	
func _show_craft():
	_hide_all()
	player_inventory_container.show()
	craft_container.show()

func _show_chest(inventory:Inventory):
	root.show()
	_hide_all()
	player_inventory_container.show()
	chest_inventory_container.show()
	chest_inventory_ui._update(inventory)
	
	var callable = _on_chest_inventory_changed.bind(inventory)
	if _prev_chest_inventory and _prev_chest_inventory.invetory_changed.is_connected(callable):
		_prev_chest_inventory.invetory_changed.disconnect(callable)
	_prev_chest_inventory = inventory
	inventory.invetory_changed.connect(callable)
	
	var callable2 = Globals.hand_slot.handle_input_click_event.bind(inventory)
	if chest_inventory_ui.slot_pressed.is_connected(callable2):
		chest_inventory_ui.slot_pressed.disconnect(callable2)
	chest_inventory_ui.slot_pressed.connect(callable2)
	
	
## OnSignal
func _on_player_invetory_changed(player_inventory:PlayerInventory):
	player_inventory_ui._update(player_inventory)
	_on_hotbar_changed()

func _on_hotbar_changed():
	Globals.hotbar.update_hotbar(Globals.player_inventory)
	hotbar_ui._update(Globals.hotbar)

func _on_hand_slot_changed():
	hand_slot_ui._update(Globals.hand_slot)
	
# ----------------------- chest
func _on_chest_inventory_changed(inventory:Inventory):
	if not chest_inventory_ui.visible:
		return 
	chest_inventory_ui._update(inventory)
	











