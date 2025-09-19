extends CharacterBody2D

@onready var jumper: Jumper = %Jumper
@onready var ground_mover: GroundMover = %GroundMover

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_jump"):
		jumper.jump()
	
	ground_mover.set_move_input(
		Input.get_axis("move_left", "move_right")
	)
	
	move_and_slide()
