extends CanvasLayer

@onready var root = $Control/Root


@onready var player_inventory_ui := %PlayerInventoryUI as InventoryUI
@onready var hand_slot_ui = %HandSlotUI as InventorySlotUI
@onready var crafting_panel := %CraftingPanel
@onready var hotbar_ui = %HotbarUI


@onready var close_button = %CloseButton

@onready var main_container = %MainContainer
@onready var player_inventory_container = %PlayerInventoryContainer
@onready var craft_container = %CraftContainer
@onready var chest_inventory_container = %ChestInventoryContainer
@onready var chest_inventory_ui = %ChestInventoryUI
var _prev_chest_inventory:Inventory


func _ready():
	close_button.pressed.connect(root.hide)
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
	Globals.player_inventory.inventory_changed.connect(_on_player_invetory_changed.bind(player_inventory))
	
	## player_inventory_ui
	player_inventory_ui.slot_pressed.connect(
		_on_slot_pressed.bind(player_inventory)
	)
	## hand_inventory
	var hand_inventory = Globals.hand_inventory
	hand_inventory.inventory_changed.connect(_on_hand_inventory_changed)
	
	
	## hotbar
	var hotbar = Globals.hotbar
	hotbar.hotbar_changed.connect(_on_hotbar_changed)
	hotbar_ui.slot_pressed.connect(_on_hotbar_slot_pressed)

	## initialize
	player_inventory_ui._initialize(player_inventory)
	hotbar_ui._initialize(hotbar)
	hand_slot_ui._initialize(hand_inventory)

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
	if _prev_chest_inventory and _prev_chest_inventory.inventory_changed.is_connected(callable):
		_prev_chest_inventory.inventory_changed.disconnect(callable)
	_prev_chest_inventory = inventory
	inventory.inventory_changed.connect(callable)
	
	var callable2 = _on_slot_pressed.bind(inventory)
	if chest_inventory_ui.slot_pressed.is_connected(callable2):
		chest_inventory_ui.slot_pressed.disconnect(callable2)
	chest_inventory_ui.slot_pressed.connect(callable2)
	
	
## OnSignal
func _on_slot_pressed(index:int, inventory:Inventory):
	## NOTE:此方法用于处理与slot交互时的事件
	var hand_inventory := Globals.hand_inventory as Inventory
	match Globals.button_index:
		MOUSE_BUTTON_LEFT:
			#Inventory.interact(Globals.hand_inventory, 0, inventory, index)
			var hand_has_slot = hand_inventory.has_slot(0)
			var inventory_has_slot = inventory.has_slot(index)
			if not hand_has_slot and not inventory_has_slot:
				return
			elif not inventory_has_slot:
				var slot = hand_inventory.get_slot(0)
				inventory.override_slot(index, slot[0], slot[1])
				hand_inventory.remove_slot(0)
			elif not hand_has_slot:
				var slot = inventory.get_slot(index)
				hand_inventory.override_slot(0, slot[0], slot[1])
				inventory.remove_slot(index)
			else:
				# 两边都有东西 一样的话手上的放下去 否则直接交换
				var slot = inventory.get_slot(index)
				var hand_slot = hand_inventory.get_slot(0)
				if slot[0] == hand_slot[0]:
					var max_count = DatatableManager.get_item_max_count(slot[0])
					var target_amount = slot[1]
					var hand_amount = hand_slot[1]
					if max_count <= target_amount: # 如果是满的就会交换
						hand_inventory.override_slot(0, slot[0], slot[1])
						inventory.override_slot(index, hand_slot[0], hand_slot[1])
					else:
						var space_amount = max_count -target_amount
						var real_transfer = hand_amount if hand_amount <= space_amount else space_amount
						hand_amount -= real_transfer
						hand_inventory.override_slot(0, slot[0], hand_amount)
						inventory.override_slot(index, hand_slot[0], target_amount+real_transfer)
					
				else:
					hand_inventory.override_slot(0, slot[0], slot[1])
					inventory.override_slot(index, hand_slot[0], hand_slot[1])

func _on_player_invetory_changed(player_inventory:PlayerInventory):
	player_inventory_ui._update(player_inventory)
	_on_hotbar_changed()

func _on_hotbar_changed():
	Globals.hotbar.update_hotbar(Globals.player_inventory)
	hotbar_ui._update(Globals.hotbar)

func _on_hotbar_slot_pressed(index:int):
	match Globals.button_index:
		MOUSE_BUTTON_LEFT: 
			Globals.hotbar.interact_with_hotbar(index, Globals.hand_inventory, Globals.player_inventory)
		MOUSE_BUTTON_RIGHT: 
			pass
		MOUSE_BUTTON_MIDDLE:
			Globals.hotbar.remove_hotbar_item(index)

func _on_hand_inventory_changed():
	hand_slot_ui._update(Globals.hand_inventory)
	
# ----------------------- chest
func _on_chest_inventory_changed(inventory:Inventory):
	if not chest_inventory_ui.visible:
		return 
	chest_inventory_ui._update(inventory)
	











