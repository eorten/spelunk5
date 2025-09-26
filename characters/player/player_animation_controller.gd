class_name AnimationController extends AnimatedSprite2D

var _locked: bool = false
enum MoveState{IDLE, WALK, JUMP, LAND, FALL}

var _queued_state = MoveState.IDLE
var last_state:MoveState
func set_state(new_state:MoveState):
	if new_state == last_state: return
	swap_animation_state(new_state)
	
func swap_animation_state(new_animation_state:MoveState):
	if _locked:
		_queued_state = new_animation_state
		return
	last_state = new_animation_state
	match new_animation_state:
		MoveState.WALK:
			play("walk_start")
		MoveState.JUMP:
			play("jump")
		MoveState.FALL:
			play("fall")
		MoveState.LAND:
			play("land")
			_locked = true
		MoveState.IDLE:
			play("idle")

func set_direction(dir:float):
	var x_scale = roundf(dir)
	scale.x = x_scale if x_scale else scale.x

func _on_animation_finished():
	match last_state:
		MoveState.WALK:
			play("walk")
		MoveState.LAND:
			play("idle")
	_locked = false
	if _queued_state:
		swap_animation_state(_queued_state)
		_queued_state = null
		
