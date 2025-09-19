class_name Gravity extends Node
@export var body:CharacterBody2D

func _physics_process(delta: float) -> void:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
