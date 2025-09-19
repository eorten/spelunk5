class_name Jumper extends Node
@export var jump_velocity:float
@export var body:CharacterBody2D

func jump():
	if body.is_on_floor():
		body.velocity.y = jump_velocity
