class_name Dropper extends Node
@export var body:CharacterBody2D

func drop():
	if body.is_on_floor():
		body.position.y += 1
