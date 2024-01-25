extends Node
"""
此管理器依赖 addons: excel_reader
"""

signal load_complated

var item_type := {}   # { "NATURAL_RESOURCES": 1, "LOGISTICS": 2, "PRODUCTIONS": 3, "INTERMEDIA_PRODUCTS": 4 }
var item_datas := {}  # { "COAL": { "id": "COAL", "name": "coal", "type": 1 }
var base_items := {}  # {"COAL": BaseItem } 

func _ready():
	pass

func load_resource():
	var table_path = AssetUtility.get_datatable_path("datatable.xlsx")
	var data = _get_excel_data(table_path)
	
	if data.has("item_type"):
		item_type = {}
		for id in data["item_type"]:
			var type_name = data["item_type"][id].name
			item_type[type_name.to_upper()] = id
		
	if data.has("items"):
		item_datas = data["items"]
		base_items = {}
		for id in data["items"]:
			var item_data = data["items"][id]
			var file_name = item_data.name.replace(" ","_")  # iron_ore
			var base_item = BaseItem.new()
			base_item.id = id
			base_item.name = item_data.name
			var path = AssetUtility.get_atlas_texture_resource_path(file_name)
			if FileAccess.file_exists(path):
				base_item.texture = load(path)
			base_items[base_item.id] = base_item
		print(base_items.keys())
	load_complated.emit()

## Interface
func get_item_type(id:String):
	return DatatableManager.item_datas[id].type

## Utils
#region Excel

func _get_excel_data(table_path:String):
	assert(FileAccess.file_exists(table_path), "file not exists")
	var excel = ExcelFile.open_file(table_path)
	var workbook = excel.get_workbook()
	var data = {}
	for sheet_name in workbook.get_sheet_name_list():
		var sheet = workbook.get_sheet(sheet_name) as ExcelSheet
		data[sheet_name] = _conver_sheet(sheet)
	return data

func _conver_sheet(sheet:ExcelSheet, key_index:int=0):
	var sheet_data = {}
	var table_data = sheet.get_table_data()
	var key_list = []
	var type_list = []
	for row_index in table_data:
		var column_data = table_data[row_index]
		var sheet_sub_data = {}
		for column_index in column_data:
			var cell = column_data[column_index]
			if typeof(cell) == TYPE_STRING:
				cell = cell.strip_edges()
			match row_index:
				1:
					key_list.append(cell)
				2: 
					pass
				3: 
					type_list.append(cell)
				_:
					var key = key_list[column_index-1]
					if key.begins_with("__"):
						continue
					var type = type_list[column_index-1]
					sheet_sub_data[key] = _convert_data_type(cell, type)
		if not sheet_sub_data:
			continue
		var sheet_key = sheet_sub_data[key_list[key_index]]
		sheet_data[sheet_key] = sheet_sub_data

	return sheet_data

func _convert_data_type(data, type:String):
	match type:
		"string": return String(data)
		"int": return int(data)
		"float": return float(data)
		_: assert(false, "unknown data type")
	

#endregion
	








