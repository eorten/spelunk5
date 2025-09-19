extends CharacterBody2D
@onready var right_ray: RayCast2D = %RightRay
@onready var left_ray: RayCast2D = %LeftRay
@onready var right_ground_ray: RayCast2D = %RightGroundRay
@onready var left_ground_ray: RayCast2D = %LeftGroundRay

@onready var ground_mover: GroundMover = %GroundMover
@export var idle_time:float = 3.0
@export var move_time:float = 1.5
var _cur_action_time = 0.0
enum States{IDLE, MOVE_LEFT, MOVE_RIGHT}
var _current_state:States

func _ready() -> void:
	_current_state = States.IDLE

func _process(delta: float) -> void:
	_cur_action_time += delta
	match _current_state:
		States.IDLE:
			ground_mover.set_move_input(0.0)
			if _cur_action_time >= idle_time:
				_cur_action_time = 0.0
				_start_move()
				
		States.MOVE_LEFT:
			ground_mover.set_move_input(-1.0)
			if !_can_move_left():
				_current_state = States.IDLE
				_cur_action_time = 0.0
				return
			if _cur_action_time >= move_time:
				_cur_action_time = 0.0
				_current_state = States.IDLE
				
		States.MOVE_RIGHT:
			ground_mover.set_move_input(1.0)
			if !_can_move_right():
				_current_state = States.IDLE
				_cur_action_time = 0.0
				return
			if _cur_action_time >= move_time:
				_cur_action_time = 0.0
				_current_state = States.IDLE
func _start_move():
	if right_ray.is_colliding() or !right_ground_ray.is_colliding():
		_current_state = States.MOVE_LEFT
	elif left_ray.is_colliding() or !left_ground_ray.is_colliding():
		_current_state = States.MOVE_RIGHT
	else:
		_current_state = States.MOVE_RIGHT if randf() > .5 else States.MOVE_LEFT

func _can_move_left():
	if !left_ground_ray.is_colliding() or left_ray.is_colliding():
		return false
	return true

func _can_move_right():
	if !right_ground_ray.is_colliding() or right_ray.is_colliding():
		return false
	return true

func _physics_process(delta: float) -> void:
	move_and_slide()
