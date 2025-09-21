class_name Interactible extends Area2D
signal on_interacted

@export var interact_label:Label
@export var interact_text:String #What does interacting do
var player_in_range := false as bool
func _ready() -> void:
	_hide()
	var interact_button = ""
	for input_event in InputMap.action_get_events("action_interact"):
		interact_button = (input_event.as_text())
		break

	interact_label.text = "Press [" + interact_button + "] to " + interact_text
	
	body_entered.connect(func(body: Node):
		if body.is_in_group("player"):
			interact_label.visible = true
			player_in_range = true
	)
	
	body_exited.connect(func(body: Node):
		if body.is_in_group("player"):
			_hide()
	)

func _hide():
	interact_label.visible = false
	player_in_range = false
	
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("action_interact"):
		on_interacted.emit()
