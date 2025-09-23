class_name HUDState extends RefCounted

var battery_percent:float
var hp:int
var playtime:float
var inventory_dict:Dictionary
var placeable_dict:Dictionary
var selected_placeable:int #not added
func _init(battery_percent:float, hp:int, playtime:float, inventory_dict:Dictionary, placeable_dict:Dictionary, selected_placeable:PlaceableTypes.Type):
	self.battery_percent = battery_percent
	self.hp = hp
	self.playtime = playtime
	self.inventory_dict = inventory_dict
	self.placeable_dict = placeable_dict
	self.selected_placeable = selected_placeable
