extends Node
func _ready() -> void:
	$Interactible.on_interacted.connect(GameEventBus.on_player_hatch_interacted.emit)
