extends CharacterBody2D

@onready var jumper: Jumper = %Jumper
@onready var ground_mover: GroundMover = %GroundMover
@onready var dropper: Dropper = %Dropper

func initialize():
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_place"):
		GameEventBus.on_player_try_place.emit(get_global_mouse_position())
		
	if Input.is_action_just_pressed("action_mine"):
		GameEventBus.on_player_try_mine.emit(get_global_mouse_position())
	
	if Input.is_action_just_pressed("move_jump"):
		jumper.jump()
	
	if Input.is_action_pressed("move_drop"):
		dropper.drop()
	
	ground_mover.set_move_input(
		Input.get_axis("move_left", "move_right")
	)
	
	move_and_slide()
