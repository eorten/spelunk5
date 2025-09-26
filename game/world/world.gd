class_name World extends RefCounted

const TILE_SIZE = 8
signal on_cell_changed(pos)
signal on_occluder_changed

#region data
var _world_size:int
var _biome_type:BiomeTypes.Type
var _biome_data:BiomeData
var _biome_visuals:BiomeVisuals
#endregion

#region representatino
var _world_cells:Dictionary[Vector2i, TileType.Type]
var _world_placeables:Dictionary[Vector2i, PlaceableTypes.Type]
var _visible_cells:BitMap
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
	_visible_cells = BitMap.new()
	_visible_cells.create(Vector2i(size, size))

func set_world_cells(world_cells:Dictionary[Vector2i, TileType.Type]):
	_world_cells = world_cells

func remove_cell(pos:Vector2i):
	
	_world_cells.set(pos, TileType.Type.AIR)
	if _world_placeables.has(pos):
		_world_placeables.set(pos, PlaceableTypes.Type.EMPTY)
	on_cell_changed.emit(pos)

func set_world_placeable(type:PlaceableTypes.Type, pos:Vector2i):
	_world_cells[pos] = TileType.Type.PLACEABLE
	_world_placeables[pos] = type
	on_cell_changed.emit(pos)

func tile_is_unmineable(pos:Vector2i):
	var placeable = _world_placeables.get(pos, PlaceableTypes.Type.EMPTY)
	var terrain = _world_cells.get(pos)
	#print( PlaceableTypes.Type.keys()[placeable])
	#print( TileType.Type.keys()[terrain])
	#return (terrain == TileType.Type.AIR && placeable == PlaceableTypes.Type.EMPTY) or (terrain == TileType.Type.PLACEABLE && placeable == PlaceableTypes.Type.SPAWN)
	return terrain == TileType.Type.AIR or terrain == TileType.Type.STONE or placeable == PlaceableTypes.Type.SPAWN
func tile_is_air(pos:Vector2i):
	var placeable = _world_placeables.get(pos, PlaceableTypes.Type.EMPTY)
	var terrain = _world_cells.get(pos)
	return (terrain == TileType.Type.AIR && placeable == PlaceableTypes.Type.EMPTY) or (terrain == TileType.Type.PLACEABLE && placeable == PlaceableTypes.Type.SPAWN)
	#return terrain == TileType.Type.AIR or terrain == TileType.Type.STONE or placeable == PlaceableTypes.Type.SPAWN
func terrain_at_pos_is(pos:Vector2i, type:TileType.Type):
	var terrain = _world_cells.get(pos)
	return terrain == type

func set_player_spawnpoint():
	for pos:Vector2i in _world_cells.keys():
		if _world_cells.get(pos) == TileType.Type.AIR:
			while _world_cells.get(Vector2i(pos.x, pos.y + 1)) == TileType.Type.AIR:
				pos = Vector2i(pos.x, pos.y + 1)
			_spawnpoint = pos
			return

func cell_exists(pos:Vector2i):
	return pos.x > 0 and pos.x < _world_size and pos.y > 0 and pos.y < _world_size

func discover_tile(pos:Vector2i):
	#if _visible_cells.get_bitv(pos):return; #no new tile discovered
	_remove_occluder_recursive(pos)
	on_occluder_changed.emit()

func _remove_occluder_recursive(start_pos:Vector2i):
	var queue: Array[Vector2i] = [start_pos]
	var visited: = {}

	while queue.size() > 0:
		var pos: Vector2i = queue.pop_front()
		if pos in visited:
			continue
		visited[pos] = true

		_visible_cells.set_bitv(pos, true)

		# Check tile
		#var tile_at_pos: Tile = terrain_tile_map.get_tile(pos)
		if !cell_exists(pos):continue;
		var tile_at_pos = _world_cells.get(pos) as TileType.Type
		if tile_at_pos != TileType.Type.AIR and tile_at_pos != TileType.Type.PLACEABLE: 
			continue;

		# Enqueue neighbors
		for new_pos in _get_surrounding_cells(pos):
			if not visited.has(new_pos):
				queue.append(new_pos)

var _neighbour_pos = [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]
func _get_surrounding_cells(pos:Vector2i):
	var res = []
	for n_pos in _neighbour_pos:
		res.append(pos + n_pos)
	return res
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
func get_visible_cells() -> BitMap:
	return _visible_cells
static func snap_pos_to_grid_offset(pos:Vector2i) -> Vector2i:
	return (pos - Vector2i(4, 4)).snapped(Vector2i(TILE_SIZE, TILE_SIZE)) + Vector2i(4, 4)

static func snap_pos_to_grid(pos:Vector2i) -> Vector2i:
	return pos.snapped(Vector2i(TILE_SIZE, TILE_SIZE)) 
static func cell_to_global(pos:Vector2i) -> Vector2i:
	return pos*TILE_SIZE
static func global_to_cell(pos:Vector2i) -> Vector2i:
	return pos/TILE_SIZE
static func global_to_cell_depricated(pos:Vector2i) -> Vector2i:
	return (pos/TILE_SIZE).snapped(Vector2(TILE_SIZE,TILE_SIZE))
