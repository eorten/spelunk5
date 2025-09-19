class_name UI extends CanvasLayer
@onready var main_menu_screen: Control = %MainMenuScreen
@onready var terminal_menu_screen: Control = %TerminalMenuScreen

var state:UIState
func _ready() -> void:
	Viewmodel.ui_vm.state_changed.connect(func(new_state:UIState):
		state = new_state
		main_menu_screen.visible = (state.screen == UIState.Screen.MAIN_MENU)
		terminal_menu_screen.visible = (state.screen == UIState.Screen.TERMINAL_MENU) 
	)
