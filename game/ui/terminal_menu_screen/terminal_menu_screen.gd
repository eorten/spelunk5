class_name TerminalMenuScreen extends Node
@onready var cave_button: Button = %CaveButton
@onready var fungal_cave_button: Button = %FungalCaveButton
@onready var fiery_cave_button: Button = %FieryCaveButton
@onready var ice_cave_button: Button = %IceCaveButton
@onready var crystal_cave_button: Button = %CrystalCaveButton
@onready var deploy_button: Button = %DeployButton

@onready var select_destination_panel: PanelContainer = %SelectDestinationPanel
@onready var destination_selected_panel: PanelContainer = %DestinationSelectedPanel
@onready var terminal_text: Label = %TerminalText

@onready var location_label: Label = %LocationLabel

#region right bar
@onready var energy_label: Label = %EnergyLabel
@onready var ore_label: Label = %OreLabel
#endregion

var state:TerminalMenuState
func _ready() -> void:
	cave_button.pressed.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.CAVE))
	fungal_cave_button.pressed.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.FUNGAL))
	fiery_cave_button.pressed.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.LAVA))
	ice_cave_button.pressed.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.ICE))
	crystal_cave_button.pressed.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.CRYSTAL))
	deploy_button.pressed.connect(EventBus.on_button_pressed_deploy.emit)
	
	Viewmodel.terminal_menu_screen_vm.state_changed.connect(func(new_state:TerminalMenuState):
		state = new_state
		select_destination_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.SELECT_DESTINATION)
		destination_selected_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.DESTINATION_SELECTED)
		location_label.text = BiomeTypes.Type.keys()[state.selected_destination]
	)
	Viewmodel.terminal_vm.state_changed.connect(func(new_state:TerminalState):
		terminal_text.text = new_state.text
	)
	Viewmodel.terminal_menu_right_vm.state_changed.connect(func(new_state:TerminalMenuRightState):
		energy_label.text = "Energy: " + str(new_state.energy)
		ore_label.text = ""
		for k in new_state.ores:
			ore_label.text += str(k) + ": " + str(new_state.ores[k])
	)

#func set_state(new_state:TerminalMenuState):
	#state = new_state
	#select_destination_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.SELECT_DESTINATION)
	#destination_selected_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.DESTINATION_SELECTED)
	#location_label.text = str(state.selected_destination)
