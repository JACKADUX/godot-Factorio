extends PanelContainer


@onready var texture_rect = %TextureRect
@onready var label = %Label
@onready var work_progress_bar = %WorkProgressBar
@onready var inventory_ui = %InventoryUI
@onready var work_h_box_container = %WorkHBoxContainer


var _prev:BaseEntity
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()

func get_inventory(entity):
	var entity_inventory
	var id = entity.get_item_id()
	if id == "IRON_CHEST":
		entity_inventory = entity.inventory
	elif id == "INSERTER_1":
		entity_inventory = entity._inventory
	return entity_inventory

func update(entity:BaseEntity):
	if _prev:
		var entity_inventory = get_inventory(_prev)
		if entity_inventory:
			entity_inventory.inventory_changed.disconnect(inventory_ui._update.bind(entity_inventory))	
		if _prev.is_worker:
			_prev.work_progress.disconnect(work_progress_bar.set_value)
	if not entity:
		_prev = null
		hide()
		return 
	
	_prev = entity
	show()
	var id = entity.get_item_id()
	label.text = id
	var entity_inventory = get_inventory(entity)
	if entity_inventory:
		entity_inventory.inventory_changed.connect(inventory_ui._update.bind(entity_inventory))	
		inventory_ui._update(entity_inventory)
	if entity.is_worker:
		work_h_box_container.show()
		entity.work_progress.connect(work_progress_bar.set_value)
	else:
		work_h_box_container.hide()

