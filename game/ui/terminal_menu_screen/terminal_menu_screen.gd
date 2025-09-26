class_name TerminalMenuScreen extends Node
@onready var cave_button: Button = %CaveButton
@onready var fungal_cave_button: Button = %FungalCaveButton
@onready var fiery_cave_button: Button = %FieryCaveButton
@onready var ice_cave_button: Button = %IceCaveButton
@onready var crystal_cave_button: Button = %CrystalCaveButton
@onready var deploy_button: Button = %DeployButton
@onready var quota_label: Label = %QuotaLabel

@onready var select_destination_panel: PanelContainer = %SelectDestinationPanel
@onready var destination_selected_panel: PanelContainer = %DestinationSelectedPanel
@onready var shop_panel: PanelContainer = %ShopPanel
@onready var shop_item_container: VBoxContainer = %ShopItemContainer

@onready var terminal_text: Label = %TerminalText

@onready var location_label: Label = %LocationLabel

#region right bar
@onready var energy_label: Label = %EnergyLabel
@onready var ore_label: Label = %OreLabel
#endregion

#region menu
@onready var move_button: Button = %MoveButton
@onready var shop_button: Button = %ShopButton
#endregion

var state:TerminalMenuState
func _ready() -> void:
	shop_button.button_up.connect(EventBus.on_button_pressed_open_shop.emit)
	move_button.button_up.connect(EventBus.on_button_pressed_open_move.emit)
	cave_button.button_up.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.CAVE))
	fungal_cave_button.button_up.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.FUNGAL))
	fiery_cave_button.button_up.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.LAVA))
	ice_cave_button.button_up.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.ICE))
	crystal_cave_button.button_up.connect(func():EventBus.on_button_pressed_move_location.emit(BiomeTypes.Type.CRYSTAL))
	deploy_button.button_up.connect(EventBus.on_button_pressed_deploy.emit)
	
	Viewmodel.terminal_menu_screen_vm.state_changed.connect(func(new_state:TerminalMenuState):
		state = new_state
		select_destination_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.SELECT_DESTINATION)
		destination_selected_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.DESTINATION_SELECTED)
		shop_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.SHOP)
		location_label.text = BiomeTypes.Type.keys()[state.selected_destination]
	)
	Viewmodel.terminal_vm.state_changed.connect(func(new_state:TerminalState):
		terminal_text.text = new_state.text
	)
	Viewmodel.terminal_menu_right_vm.state_changed.connect(func(new_state:TerminalMenuRightState):
		quota_label.text = "Quota: " + str(new_state.quota)
		energy_label.text = "Energy: " + str(new_state.energy)
		ore_label.text = ""
		for k in new_state.ores:
			ore_label.text += str(k) + ": " + str(new_state.ores[k])
	)
	Viewmodel.terminal_menu_shop_vm.state_changed.connect(func(new_state:TerminalMenuShopState):
		var player_has_dict = new_state.player_placeable_dict #Dictionary[PlaceableTypes.Type, int]
		var dict:Dictionary[PlaceableTypes.Type, int] = new_state.item_dict
		for child in shop_item_container.get_children():
			if child is not Button: continue;
			child.queue_free()
		for placeable in dict.keys():
			var new_item := Button.new() as Button
			new_item.text = str(PlaceableTypes.Type.keys()[placeable]) + " - " + str(dict[placeable]) + "$ (has " +str(player_has_dict.get(placeable, 0)) +")"
			new_item.alignment = HORIZONTAL_ALIGNMENT_LEFT
			shop_item_container.add_child(new_item)
			new_item.button_up.connect(func():
				EventBus.on_button_pressed_buy.emit(placeable)
			)
	)

#func set_state(new_state:TerminalMenuState):
	#state = new_state
	#select_destination_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.SELECT_DESTINATION)
	#destination_selected_panel.visible = (state.center_panel_state == TerminalMenuState.CenterPanelState.DESTINATION_SELECTED)
	#location_label.text = str(state.selected_destination)
