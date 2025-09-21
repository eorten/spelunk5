class_name PlayerData extends RefCounted
var _inventory:Inventory
var _currency:int
func _init() -> void:
	_currency = 0
	_inventory = Inventory.new()

func add_currency(amount:int):
	_currency += amount

func get_inventory() -> Inventory:
	return _inventory
