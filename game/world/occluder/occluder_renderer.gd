extends Node2D
@onready var tile_map_layer: TileMapLayer = %TileMapLayer

var _world:World
func initialize(world:World):
	_world = world

func set_occluders():
	var visible_tiles := _world.get_visible_cells() as BitMap
	for y in visible_tiles.get_size().y:
		for x in visible_tiles.get_size().x:
			if visible_tiles.get_bit(x,y):
				tile_map_layer.set_cell(Vector2i(x,y))
				continue;
			tile_map_layer.set_cell(Vector2i(x,y), 0, Vector2i.ZERO)
