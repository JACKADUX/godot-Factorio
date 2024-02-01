extends PanelContainer


@onready var texture_rect = %TextureRect
@onready var label = %Label
@onready var work_progress_bar = %WorkProgressBar
@onready var inventory_ui = %InventoryUI
@onready var work_h_box_container = %WorkHBoxContainer

@onready var productivity_h_box_container = %ProductivityHBoxContainer
@onready var productivity_progress_bar = $VBoxContainer/ProductivityHBoxContainer/ProductivityProgressBar
@onready var fuel_h_box_container = %FuelHBoxContainer
@onready var fuel_progress_bar = $VBoxContainer/FuelHBoxContainer/FuelProgressBar

@onready var input_inventory_ui = %InputInventoryUI
@onready var fuel_inventory_ui = %FuelInventoryUI
@onready var output_inventory_ui = %OutputInventoryUI

@onready var inventory_h_box_container = %InventoryHBoxContainer
@onready var input_inventory_h_box_container = %InputInventoryHBoxContainer
@onready var fuel_inventory_h_box_container = %FuelInventoryHBoxContainer
@onready var output_inventory_h_box_container = %OutputInventoryHBoxContainer


var _prev:BaseEntity
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	
	if not _prev:
		return 
	var data = _prev.get_entity_data()
	if data.has("inventory"):
		inventory_ui._update(data.inventory)
	if data.has("work_progress"):
		work_progress_bar.value = data.work_progress
	if data.has("productivity_progress"):
		productivity_progress_bar.value = data.productivity_progress
	if data.has("fuel_progress"):
		fuel_progress_bar.value = data.fuel_progress
	if data.has("input_inventory"):
		input_inventory_ui._update(data.input_inventory)
	if data.has("fuel_inventory"):
		fuel_inventory_ui._update(data.fuel_inventory)
	if data.has("output_inventory"):
		output_inventory_ui._update(data.output_inventory)
		
func update(entity:BaseEntity):
	if not entity:
		_prev = null
		hide()
		return 
	size = Vector2.ZERO
	_prev = entity
	show()
	var data = _prev.get_entity_data()
	
	label.text = data.id
	inventory_h_box_container.visible = data.has("inventory")
	input_inventory_h_box_container.visible = data.has("input_inventory")
	fuel_inventory_h_box_container.visible = data.has("fuel_inventory")
	output_inventory_h_box_container.visible = data.has("output_inventory")
	work_h_box_container.visible = data.has("work_progress")
	productivity_h_box_container.visible = data.has("productivity_progress")
	fuel_h_box_container.visible = data.has("fuel_progress")

