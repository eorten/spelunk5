class_name WorldRoot extends Node2D
## Visuals and interface for World 
@export var player_prefab:PackedScene
@onready var terrain_renderer: TerrainRenderer = %TerrainRenderer

var _player:Node2D
var _world:World
var _placeable_registry:Dictionary[PlaceableTypes.Type, PackedScene]
func initialize(world:World, placeable_registry:Dictionary) -> void:
	_world = world
	_world.on_cell_changed.connect(render_tile)
	_placeable_registry = placeable_registry

func create_world():
	var generator := TerrainGenerator.new() as TerrainGenerator
	_world.set_world_cells(generator.create_terrain(_world.get_size(), _world.get_biome_data())) #Dict with cell type (DIRT, STONE, ORE_UNCOMMON etc)
	_create_spawnpoint()
	_create_enemies()
	
func despawn_player():
	_player.queue_free()
	
func _create_spawnpoint():
	_world.set_player_spawnpoint()
	_world.set_world_placeable(PlaceableTypes.Type.SPAWN, _world.get_spawnpoint())

func render_world():
	terrain_renderer.render(_world.get_world_cells(), _world.get_world_placeables(), _placeable_registry, _world.get_biome_visuals())
	_spawn_enemies()

func render_tile(pos:Vector2i):
	terrain_renderer.re_render_cell(pos, _world.get_world_cells(), _world.get_world_placeables(), _placeable_registry, _world.get_biome_visuals())

func spawn_player():
	_player = player_prefab.instantiate()
	add_child(_player)
	_player.position = World.cell_to_global(_world.get_spawnpoint()) 
	_player.initialize()

func remove_cell(pos:Vector2i):
	_world.remove_cell(pos)

func _create_enemies():
	pass

func _spawn_enemies():
	pass
	
