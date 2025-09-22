extends Node
@warning_ignore_start("unused_signal")
#Main menu
signal on_button_pressed_start_game

#region Terminal menu
#move
signal on_button_pressed_move_location(biome:BiomeTypes.Type)
signal on_button_pressed_deploy
#change screen
signal on_button_pressed_open_shop
signal on_button_pressed_open_move
#buy item
signal on_button_pressed_buy(placeable:PlaceableTypes.Type)
#endregion

#region HUD
signal on_button_pressed_select_placeable(placeable:PlaceableTypes.Type)
#endregion
