class_name AssetUtility extends RefCounted

const WORLD = preload("res://scenes/world.tscn")


static func get_datatable_path(file_name:String):
	return r"res://resource/datatables/"+ file_name

static func get_item_resource_path(file_name:String):
	return r"res://resource/item_resources/"+ file_name+".tres"

static func get_atlas_texture_resource_path(file_name:String):
	return r"res://resource/atlas_texture_resources/"+ file_name+".tres"


