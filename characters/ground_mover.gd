class_name GroundMover extends Node
@export var speed:float
@export var body:CharacterBody2D

var _move_input:float
func set_move_input(input:float):
	_move_input = input
	
func _physics_process(delta: float) -> void:
	if _move_input:
		body.velocity.x = _move_input * speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed)
