extends Node
@warning_ignore_start("unused_signal")
#Main menu
signal on_button_pressed_start_game

#region Terminal menu
#move
signal on_button_pressed_move_location(biome:BiomeTypes.Type)
signal on_button_pressed_deploy
#endregion
