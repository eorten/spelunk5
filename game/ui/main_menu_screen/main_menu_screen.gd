class_name MainMenuScreen extends Control
@onready var start_game_button: Button = %StartGameButton

func _ready() -> void:
	start_game_button.button_up.connect(EventBus.on_button_pressed_start_game.emit)
