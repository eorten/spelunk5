extends Node

enum GameState{PLAYING, BETWEEN_RUN, BETWEEN_ROUND} #Every X runs a new round is started

@onready var ui: CanvasLayer = %UI
@onready var world_root: WorldRoot = %WorldRoot

@export var world_size:int #can move to a config later
@export var placeable_registry:Dictionary[PlaceableTypes.Type, PackedScene] #Move to worldroot?
@export_group("Biomes")
@export var biomes_data_registry:Dictionary[BiomeTypes.Type, BiomeData]
@export var biomes_visual_registry:Dictionary[BiomeTypes.Type, BiomeVisuals]
@export var base_boime_data:BiomeData
@export var base_boime_visuals:BiomeVisuals

var _current_gamestate:GameState
var _current_round_data:RoundData
var _player_data:PlayerData
var _player:Player
var _world:World
var _mining_system:MiningSystem
func _ready() -> void:
	#Connect events
	EventBus.on_button_pressed_start_game.connect(func():
		Viewmodel.ui_vm.set_state(
			UIState.new(UIState.Screen.TERMINAL_MENU)
		)
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.SELECT_DESTINATION)
		)
	)
	
	EventBus.on_button_pressed_move_location.connect(func(biome:BiomeTypes.Type):
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.DESTINATION_SELECTED, biome)
		)
		_world = World.new(world_size, biomes_data_registry[biome], biomes_visual_registry[biome], base_boime_data, base_boime_visuals)
		_mining_system = MiningSystem.new(_world)
		world_root.initialize(_world, placeable_registry)
		world_root.create_world()
		_current_round_data = RoundData.new(-1)
	)
	
	EventBus.on_button_pressed_deploy.connect(func():
		_current_gamestate = GameState.PLAYING
		if Viewmodel.terminal_menu_screen_vm.get_state().center_panel_state != TerminalMenuState.CenterPanelState.DESTINATION_SELECTED:
			Viewmodel.terminal_vm.set_state(TerminalState.new("select destination before deploying"))
			return;
		
		Viewmodel.ui_vm.set_state(
			UIState.new(UIState.Screen.HUD_SCREEN)
		)

		world_root.render_world()
		world_root.spawn_player()
		_player = Player.new(.5 ,1)
		_player.on_out_of_hp.connect(func():
			end_run()
			Viewmodel.terminal_vm.set_state(TerminalState.new("robot destroyed due to excessive damage"))
		)
		_player.on_out_of_energy.connect(func():
			end_run()
			Viewmodel.terminal_vm.set_state(TerminalState.new("robot destroyed due to no energy"))
		)
		_player.on_take_damage.connect(func():
			update_hud(_player)
		)
		update_hud(_player)
	)
	
	GameEventBus.on_player_hatch_interacted.connect(func():
		end_run()
	)

	GameEventBus.on_player_try_mine.connect(func(pos:Vector2i):
		_mining_system.try_mine_at(pos, _player.get_inventory())
	)
	
	#Start game
	_current_gamestate = GameState.BETWEEN_ROUND
	_player_data = PlayerData.new()
	Viewmodel.ui_vm.set_state(
		UIState.new(UIState.Screen.MAIN_MENU)
	)

func end_run():
	if _current_gamestate != GameState.PLAYING:return;
	world_root.despawn_player()
	_current_round_data.run_over()
	Viewmodel.ui_vm.set_state(
		UIState.new(UIState.Screen.TERMINAL_MENU)
	)
	if _current_round_data.round_over():
		_current_gamestate = GameState.BETWEEN_ROUND
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.SELECT_DESTINATION)
		)
	else:
		_current_gamestate = GameState.BETWEEN_RUN
		var old_state = Viewmodel.terminal_menu_screen_vm.get_state()
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.DESTINATION_SELECTED, old_state.selected_destination)
		)

func update_hud(player:Player):
	var old_state := Viewmodel.hud_vm.get_state() as HUDState
	Viewmodel.hud_vm.set_state(
		HUDState.new(player.get_energy(), player.get_hp(), player.get_playtime())
	)

func _process(delta: float) -> void:
	if _current_gamestate == GameState.PLAYING:
		_player.tick_playtime(delta)
		_player.tick_energy(delta)
		update_hud(_player)
