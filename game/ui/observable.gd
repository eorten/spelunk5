class_name Observable extends RefCounted

signal state_changed(new_state)

var _state
func get_state():
	return _state

func set_state(new_state):
	if _state != new_state:
		_state = new_state
		state_changed.emit(new_state)
