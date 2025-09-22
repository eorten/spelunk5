class_name Player extends RefCounted

signal on_out_of_energy
signal on_out_of_hp
signal on_take_damage

var _inventory:Inventory
var _playtime:float
var _energy_drain_rate:float
var _energy:float
var _max_hp:int
var _hp:int
var _selected_placeable:PlaceableTypes.Type

func _init(energy_drain_rate:float, max_hp:int) -> void:
	_energy = 100
	_energy_drain_rate = energy_drain_rate
	_max_hp = max_hp
	_hp = _max_hp
	_inventory = Inventory.new()
	_selected_placeable = PlaceableTypes.Type.EMPTY

func select_placeable(placeable:PlaceableTypes.Type):
	_selected_placeable = placeable

func get_selected_placeable() -> PlaceableTypes.Type:
	return _selected_placeable

func tick_energy(delta:float):
	_energy -= delta * _energy_drain_rate
	if _energy <= 0:
		on_out_of_energy.emit()

func tick_playtime(delta:float):
	_playtime += delta
	
func take_damage(amount:int):
	_hp -= amount
	on_take_damage.emit()
	if _hp <= 0:
		on_out_of_hp.emit()

func get_energy() -> float:
	return _energy
func get_playtime() -> float:
	return _playtime
func get_hp() -> int:
	return _hp
func get_inventory() -> Inventory:
	return _inventory
