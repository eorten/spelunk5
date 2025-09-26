class_name RoundData extends RefCounted
const RUN_ENERGY_COST := 20 as int

var _resource_quota:int
var _run_energy:int
func _init(quota:int, run_energy:int) -> void:
	_run_energy = run_energy
	_resource_quota = quota
	
func run_over():
	_run_energy -= RUN_ENERGY_COST

func round_over() -> bool:
	return _run_energy <= 0
func get_current_energy() -> int:
	return _run_energy
func get_resource_quota() -> int:
	return _resource_quota
