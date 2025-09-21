class_name UIState extends RefCounted

enum Screen{MAIN_MENU, TERMINAL_MENU, HUD_SCREEN}
var screen:Screen

func _init(screen:Screen) -> void:
	self.screen = screen
