class_name RoundData extends RefCounted
const MAX_RUN_COUNT := 2 as int

var _resource_quota:int
var _run_number:int
func _init(quota:int) -> void:
	_run_number = 0
	_resource_quota = quota
	
func run_over():
	_run_number += 1

func round_over() -> bool:
	return _run_number >= MAX_RUN_COUNT
