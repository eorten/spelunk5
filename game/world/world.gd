class_name World extends RefCounted

const TILE_SIZE = 8
var _world_cells:Dictionary[Vector2i, TileType.Type]
var _world_placeables:Dictionary[Vector2i, PlaceableTypes.Type]
var _spawnpoint:Vector2i #Globalpos

func set_world_cells(world_cells:Dictionary[Vector2i, TileType.Type]):
	_world_cells = world_cells

func get_world_cells() -> Dictionary[Vector2i, TileType.Type]:
	return _world_cells

func get_spawnpoint() -> Vector2i:
	return _spawnpoint

func get_world_placeables() -> Dictionary[Vector2i, PlaceableTypes.Type]:
	return _world_placeables

func remove_cell(pos:Vector2i):
	_world_cells.set(pos, TileType.Type.AIR)
	if _world_placeables.has(pos):
		_world_placeables.set(pos, PlaceableTypes.Type.EMPTY)

func set_world_placeable(type:PlaceableTypes.Type, pos:Vector2i):
	_world_cells[pos] = TileType.Type.PLACEABLE
	_world_placeables[pos] = type

func set_player_spawnpoint():
	for pos:Vector2i in _world_cells.keys():
		if _world_cells.get(pos) == TileType.Type.AIR:
			while _world_cells.get(Vector2i(pos.x, pos.y + 1)) == TileType.Type.AIR:
				pos = Vector2i(pos.x, pos.y + 1)
			_spawnpoint = pos
			return

static func global_to_cell(pos:Vector2i) -> Vector2i:
	return pos*TILE_SIZE
