class_name PlayerData extends RefCounted
var _inventory:Inventory
var _placeable_inventory:Inventory
func _init() -> void:
	_inventory = Inventory.new()
	_placeable_inventory = Inventory.new()

func get_inventory() -> Inventory:
	return _inventory
func get_placeable_inventory() -> Inventory:
	return _placeable_inventory
func get_currency() -> int:
	return _inventory.get_item("CURRENCY")
func remove_currency(amount:int) -> int:
	return _inventory.reduce_item("CURRENCY", amount)
