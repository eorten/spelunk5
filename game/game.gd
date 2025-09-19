extends Node

@onready var ui: CanvasLayer = %UI
@onready var world_root: WorldRoot = %WorldRoot

@export var world_size:int #can move to a config later
@export var placeable_registry:Dictionary[PlaceableTypes.Type, PackedScene] #Move to worldroot?
@export_group("Biomes")
@export var biomes_data_registry:Dictionary[BiomeTypes.Type, BiomeData]
@export var biomes_visual_registry:Dictionary[BiomeTypes.Type, BiomeVisuals]

func _ready() -> void:
	#Connect events
	EventBus.on_button_pressed_start_game.connect(func():
		Viewmodel.ui_vm.set_state(
			UIState.new(UIState.Screen.TERMINAL_MENU)
		)
		Viewmodel.terrain_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.SELECT_DESTINATION)
		)
	)
	
	EventBus.on_button_pressed_move_location.connect(func(biome:BiomeTypes.Type):
		Viewmodel.terrain_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.DESTINATION_SELECTED, biome)
		)
		#Lag world her, gi til root?
		world_root.initialize(world_size, biomes_data_registry[biome], biomes_visual_registry[biome], placeable_registry)
		world_root.create_world()
	)
	
	EventBus.on_button_pressed_deploy.connect(func():
		if Viewmodel.terrain_menu_screen_vm.get_state().center_panel_state != TerminalMenuState.CenterPanelState.DESTINATION_SELECTED:return;
		Viewmodel.ui_vm.set_state(
			UIState.new(UIState.Screen.PLAY_SCREEN)
		)
		world_root.render_world()
		
	)
	
	#Start game
	Viewmodel.ui_vm.set_state(
		UIState.new(UIState.Screen.MAIN_MENU)
	)
