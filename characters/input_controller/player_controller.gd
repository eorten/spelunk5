extends CharacterBody2D

@onready var jumper: Jumper = %Jumper
@onready var ground_mover: GroundMover = %GroundMover
@onready var dropper: Dropper = %Dropper
@onready var animation: AnimationController = $Sprite2D

func initialize():
	pass

var _mouse_pos:Vector2i
func get_player_mouse_pos() -> Vector2i:
	return _mouse_pos

func _process(delta: float) -> void:
	_mouse_pos = get_global_mouse_position()

	if Input.is_action_just_pressed("action_place"):
		GameEventBus.on_player_try_place.emit(_mouse_pos)
		
	if Input.is_action_pressed("action_mine"):
		GameEventBus.on_player_try_mine.emit(_mouse_pos)
	elif Input.is_action_just_released("action_mine"):
		GameEventBus.on_player_stop_try_mine.emit()
	
	if Input.is_action_just_pressed("move_jump"):
		jumper.jump()
	
	if Input.is_action_pressed("move_drop"):
		dropper.drop()
	
	ground_mover.set_move_input(
		Input.get_axis("move_left", "move_right")
	)
	
	#Animations
	if not is_on_floor():
		if velocity.y < 0:
			animation.set_state(AnimationController.MoveState.JUMP)
		else:
			animation.set_state(AnimationController.MoveState.FALL)
	elif animation.last_state == AnimationController.MoveState.FALL: 
		animation.set_state(AnimationController.MoveState.LAND)
	elif ground_mover._move_input != 0:
		animation.set_state(AnimationController.MoveState.WALK)
		animation.set_direction(ground_mover._move_input)
	else:
		if animation.last_state in [AnimationController.MoveState.WALK, AnimationController.MoveState.LAND]:
			animation.set_state(AnimationController.MoveState.IDLE)
	move_and_slide()
