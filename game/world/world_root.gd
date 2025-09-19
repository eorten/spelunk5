class_name WorldRoot extends Node2D

@export var base_biome_data:BiomeData
@export var base_biome_visuals:BiomeVisuals
@export var player_prefab:PackedScene
@onready var terrain_renderer: Node2D = %TerrainRenderer

#WORLD SHOULD KEEP BIOME?

var _world:World
var _world_size:int
var _biome_data:BiomeData
var _biome_visuals:BiomeVisuals
var _placeable_registry:Dictionary[PlaceableTypes.Type, PackedScene]
func initialize(size:int, biome_data:BiomeData, biome_visuals:BiomeVisuals, placeable_registry:Dictionary) -> void:
	_world = World.new()
	_world_size = size
	_biome_data = biome_data
	_biome_visuals = biome_visuals
	_placeable_registry = placeable_registry

func create_world():
	var generator := TerrainGenerator.new(base_biome_data) as TerrainGenerator
	_world.set_world_cells(generator.create_terrain(_world_size, _biome_data)) #Dict with cell type (DIRT, STONE, ORE_UNCOMMON etc)
	_create_spawnpoint()
	_create_enemies()

func _create_spawnpoint():
	_world.set_player_spawnpoint()
	_world.set_world_placeable(PlaceableTypes.Type.SPAWN, _world.get_spawnpoint())

func render_world():
	terrain_renderer.render(_world.get_world_cells(), _world.get_world_placeables(), _placeable_registry, _biome_visuals, base_biome_visuals)
	_spawn_player() #fix plyr spawn
	_spawn_enemies()

func _spawn_player():
	var player = player_prefab.instantiate()
	add_child(player)
	player.position = World.global_to_cell(_world.get_spawnpoint()) 

func remove_cell(pos:Vector2i):
	_world.remove_cell(pos)

func _create_enemies():
	pass

func _spawn_enemies():
	pass
	
