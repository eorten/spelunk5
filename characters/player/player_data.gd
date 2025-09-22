class_name PlayerData extends RefCounted
var _inventory:Inventory
func _init() -> void:
	_inventory = Inventory.new()

func get_inventory() -> Inventory:
	return _inventory
