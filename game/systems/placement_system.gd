class_name PlacementSystem extends RefCounted

var _world:World
func _init(world:World) -> void:
	_world = world
	
func try_place_at(global_pos:Vector2i , placeable:PlaceableTypes.Type) -> bool:
	var local_pos = World.global_to_cell(global_pos)
	if _world.cell_exists(local_pos) && _world.tile_is_air(local_pos):
		_world.set_world_placeable(placeable, local_pos)
		return true
	return false
