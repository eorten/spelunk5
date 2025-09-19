class_name TerminalMenuState extends RefCounted

enum CenterPanelState{SELECT_DESTINATION, DESTINATION_SELECTED}
var center_panel_state:CenterPanelState
var selected_destination:BiomeTypes.Type
func _init(center_panel_state: CenterPanelState, selected_destination: BiomeTypes.Type = 0) -> void:
	self.center_panel_state = center_panel_state
	self.selected_destination = selected_destination
