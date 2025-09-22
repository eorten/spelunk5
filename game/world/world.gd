class_name World extends RefCounted

const TILE_SIZE = 8
signal on_cell_changed(pos)

#region data
var _world_size:int
var _biome_type:BiomeTypes.Type
var _biome_data:BiomeData
var _biome_visuals:BiomeVisuals
#endregion

##region base
#var _base_biome_data:BiomeData
#var _base_biome_visuals:BiomeVisuals
##endregion

#region representatino
var _world_cells:Dictionary[Vector2i, TileType.Type]
var _world_placeables:Dictionary[Vector2i, PlaceableTypes.Type]
var _spawnpoint:Vector2i #Globalpos
#endregion

func _init(size:int, biome_data:BiomeData, biome_visuals:BiomeVisuals, base_biome_data:BiomeData, base_biome_visuals:BiomeVisuals, biome_type:BiomeTypes.Type) -> void:
	#_biome_data = biome_data
	#_biome_visuals = biome_visuals
	_biome_type = biome_type
	_world_size = size
	_biome_data = BiomeData.new()
	_biome_visuals = BiomeVisuals.new()
	_biome_data.biome_dict = biome_data.biome_dict.merged(base_biome_data.biome_dict)
	_biome_visuals.biome_dict = biome_visuals.biome_dict.merged(base_biome_visuals.biome_dict)

func set_world_cells(world_cells:Dictionary[Vector2i, TileType.Type]):
	_world_cells = world_cells

func remove_cell(pos:Vector2i):
	_world_cells.set(pos, TileType.Type.AIR)
	print("WORLD:has placeable?")
	if _world_placeables.has(pos):
		print("yes")
		_world_placeables.set(pos, PlaceableTypes.Type.EMPTY)
	on_cell_changed.emit(pos)

func set_world_placeable(type:PlaceableTypes.Type, pos:Vector2i):
	_world_cells[pos] = TileType.Type.PLACEABLE
	_world_placeables[pos] = type
	on_cell_changed.emit(pos)

func tile_is_air(pos:Vector2i):
	var placeable = _world_placeables.get(pos, PlaceableTypes.Type.EMPTY)
	var terrain = _world_cells.get(pos)
	return placeable == PlaceableTypes.Type.EMPTY && terrain == TileType.Type.AIR

func set_player_spawnpoint():
	for pos:Vector2i in _world_cells.keys():
		if _world_cells.get(pos) == TileType.Type.AIR:
			while _world_cells.get(Vector2i(pos.x, pos.y + 1)) == TileType.Type.AIR:
				pos = Vector2i(pos.x, pos.y + 1)
			_spawnpoint = pos
			return

func cell_exists(pos:Vector2i):
	return pos.x > 0 and pos.x < _world_size and pos.y > 0 and pos.y < _world_size

func get_world_cells() -> Dictionary[Vector2i, TileType.Type]:
	return _world_cells
func get_spawnpoint() -> Vector2i:
	return _spawnpoint
func get_biome_data() -> BiomeData:
	return _biome_data	
func get_biome_visuals() -> BiomeVisuals:
	return _biome_visuals
func get_size() -> int:
	return _world_size
func get_world_placeables() -> Dictionary[Vector2i, PlaceableTypes.Type]:
	return _world_placeables
	
static func cell_to_global(pos:Vector2i) -> Vector2i:
	return pos*TILE_SIZE
static func global_to_cell(pos:Vector2i) -> Vector2i:
	return pos/TILE_SIZE
static func global_to_cell_depricated(pos:Vector2i) -> Vector2i:
	return (pos/TILE_SIZE).snapped(Vector2(TILE_SIZE,TILE_SIZE))
