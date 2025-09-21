class_name UI extends CanvasLayer
@onready var main_menu_screen: Control = %MainMenuScreen
@onready var terminal_menu_screen: Control = %TerminalMenuScreen
@onready var hud_screen: Control = %HUDScreen

func _ready() -> void:
	Viewmodel.ui_vm.state_changed.connect(func(new_state:UIState):
		main_menu_screen.visible = (new_state.screen == UIState.Screen.MAIN_MENU)
		terminal_menu_screen.visible = (new_state.screen == UIState.Screen.TERMINAL_MENU) 
		hud_screen.visible = (new_state.screen == UIState.Screen.HUD_SCREEN)
	)
