class_name Health extends Node

signal entity_died(entity:Node)

@export var max_hp:int
var cur_hp:int

func _ready() -> void:
	cur_hp = max_hp
	
func take_damage(amount:int):
	cur_hp -= amount
	if cur_hp <= 0:
		entity_died.emit(get_parent())
