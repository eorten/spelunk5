extends Node

@onready var ui: CanvasLayer = %UI
@onready var world_root: WorldRoot = %WorldRoot

@export var world_size:int #can move to a config later
@export var placeable_registry:Dictionary[PlaceableTypes.Type, PackedScene] #Move to worldroot?
@export var shop:Dictionary[PlaceableTypes.Type, int] #placeable - price
@export_group("Biomes")
@export var biomes_data_registry:Dictionary[BiomeTypes.Type, BiomeData]
@export var biomes_visual_registry:Dictionary[BiomeTypes.Type, BiomeVisuals]
@export var base_boime_data:BiomeData
@export var base_boime_visuals:BiomeVisuals

var _gamestate:GameState
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
	EventBus.on_button_pressed_open_shop.connect(func():
		var old_state = Viewmodel.terminal_menu_screen_vm.get_state()
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.SHOP, old_state.selected_destination)
		)
		update_shop_ui()
	)
	EventBus.on_button_pressed_open_move.connect(func():
		var old_state = Viewmodel.terminal_menu_screen_vm.get_state()
		var screen_state = TerminalMenuState.CenterPanelState.DESTINATION_SELECTED if _gamestate.biome_selected else TerminalMenuState.CenterPanelState.SELECT_DESTINATION
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(screen_state, old_state.selected_destination)
		)
	)
	EventBus.on_button_pressed_move_location.connect(func(biome:BiomeTypes.Type):
		_gamestate.biome_selected = true
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.DESTINATION_SELECTED, biome)
		)
		_world = World.new(world_size, biomes_data_registry[biome], biomes_visual_registry[biome], base_boime_data, base_boime_visuals, biome)
		_mining_system = MiningSystem.new(_world)
		world_root.initialize(_world, placeable_registry)
		world_root.create_world()
		_current_round_data = RoundData.new(-1, 120)
		Viewmodel.terminal_vm.set_state(TerminalState.new("location changed to " + BiomeTypes.Type.keys()[biome]))
		update_resource_ui()
	)
	
	EventBus.on_button_pressed_deploy.connect(func():
		if !_gamestate.biome_selected:
			Viewmodel.terminal_vm.set_state(TerminalState.new("select destination before deploying"))
			return;
		_gamestate.state = GameState.States.PLAYING
		
		Viewmodel.ui_vm.set_state(
			UIState.new(UIState.Screen.HUD_SCREEN)
		)

		world_root.render_world()
		world_root.spawn_player()
		_player = Player.new(.5 ,1)
		_player.on_out_of_hp.connect(func():
			end_run()
			update_resource_ui()
			Viewmodel.terminal_vm.set_state(TerminalState.new("robot destroyed due to excessive damage"))
		)
		_player.on_out_of_energy.connect(func():
			end_run()
			update_resource_ui()
			
			Viewmodel.terminal_vm.set_state(TerminalState.new("robot destroyed due to no energy"))
		)
		_player.on_take_damage.connect(func():
			update_hud(_player)
		)
		update_hud(_player)
	)
	EventBus.on_button_pressed_buy.connect(func(placeable:PlaceableTypes.Type):
		var price = shop[placeable]
		if _player_data.get_currency() >= price:
			_player_data.remove_currency(price)
			Viewmodel.terminal_vm.set_state(TerminalState.new("bought "+ PlaceableTypes.Type.keys()[placeable]))
			_player_data.get_placeable_inventory().add_item(placeable)
			update_shop_ui()
			update_resource_ui()
		else:
			Viewmodel.terminal_vm.set_state(TerminalState.new("can not afford " + PlaceableTypes.Type.keys()[placeable] + " (" + str(price) + "$) with " + str(_player_data.get_currency()) + "$"))
	)
	
	GameEventBus.on_player_hatch_interacted.connect(func():
		if _gamestate.state != GameState.States.PLAYING:return;
		end_run()
		_player_data.get_inventory().add_inventory(
			_player.get_inventory()
		)
		Viewmodel.terminal_vm.set_state(TerminalState.new("extracted successfully"))
		update_resource_ui()
	)

	GameEventBus.on_player_try_mine.connect(func(pos:Vector2i):
		_mining_system.try_mine_at(pos, _player.get_inventory())
	)
	
	#Start game
	_gamestate = GameState.new(GameState.States.BETWEEN_ROUND, false)
	_player_data = PlayerData.new()
	Viewmodel.ui_vm.set_state(
		UIState.new(UIState.Screen.MAIN_MENU)
	)
	Viewmodel.terminal_vm.set_state(TerminalState.new("welcome"))
	update_resource_ui()

func update_resource_ui():
	Viewmodel.terminal_menu_right_vm.set_state(
		TerminalMenuRightState.new(
			_player_data.get_inventory().get_item("currency"),
			_current_round_data.get_current_energy() if _current_round_data else 0, 
			_player_data.get_inventory().get_inventory()
		)
	)
func update_shop_ui():
	Viewmodel.terminal_menu_shop_vm.set_state(
		TerminalMenuShopState.new(shop, _player_data.get_placeable_inventory().get_inventory())
	)
func end_run():
	if _gamestate.state != GameState.States.PLAYING:return;
	world_root.despawn_player()
	_current_round_data.run_over()
	Viewmodel.ui_vm.set_state(
		UIState.new(UIState.Screen.TERMINAL_MENU)
	)
	if _current_round_data.round_over():
		_gamestate = GameState.new(GameState.States.BETWEEN_ROUND, false)
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.SELECT_DESTINATION)
		)
	else:
		_gamestate = GameState.new(GameState.States.BETWEEN_RUN, true)
		var old_state = Viewmodel.terminal_menu_screen_vm.get_state()
		Viewmodel.terminal_menu_screen_vm.set_state(
			TerminalMenuState.new(TerminalMenuState.CenterPanelState.DESTINATION_SELECTED, old_state.selected_destination)
		)

func update_hud(player:Player):
	var old_state := Viewmodel.hud_vm.get_state() as HUDState
	Viewmodel.hud_vm.set_state(
		HUDState.new(player.get_energy(), player.get_hp(), player.get_playtime(), player.get_inventory().get_inventory(), _player_data.get_placeable_inventory().get_inventory())
	)

func _process(delta: float) -> void:
	if _gamestate.state == GameState.States.PLAYING:
		_player.tick_playtime(delta)
		_player.tick_energy(delta)
		update_hud(_player)
