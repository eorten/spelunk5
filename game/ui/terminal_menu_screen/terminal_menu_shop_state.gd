class_name TerminalMenuShopState extends RefCounted

var item_dict:Dictionary[PlaceableTypes.Type, int] #item - price
var player_placeable_dict:Dictionary #item - amount
func _init(item_dict:Dictionary[PlaceableTypes.Type, int], player_placeable_dict:Dictionary) -> void:
	self.item_dict = item_dict
	self.player_placeable_dict = player_placeable_dict
