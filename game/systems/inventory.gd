class_name Inventory extends RefCounted

var _inventory:Dictionary
func _init() -> void:
	_inventory = {}

func add_item(item):
	if _inventory.has(item):
		_inventory[item] += 1
	else:
		_inventory[item] = 1

func add_items(item, amount):
	if _inventory.has(item):
		_inventory[item] += amount
	else:
		_inventory[item] = amount
		
func get_item(item):
	return _inventory.get(item, 0)

func get_inventory() -> Dictionary:
	return _inventory

func add_inventory(to_add:Inventory):
	for item in to_add.get_inventory().keys():
		add_items(item, to_add.get_inventory()[item])
