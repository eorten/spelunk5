class_name MiningSystem extends RefCounted
## Mediator
var _world:World
func _init(world:World) -> void:
	_world = world

func try_mine_at(global_pos:Vector2i , inventory:Inventory):
	var local_pos = World.global_to_cell(global_pos)
	
	if !_world.cell_exists(local_pos): return;
	var tile_type:TileType.Type = _world._world_cells.get(local_pos, TileType.Type.AIR)
	var placeable_type:PlaceableTypes.Type = _world._world_placeables.get(local_pos, PlaceableTypes.Type.EMPTY)
	if tile_type != TileType.Type.AIR:
		var ore = null
		if _world.get_biome_data().biome_dict.has(tile_type):
			ore = _world.get_biome_data().get_entry(tile_type) as BiomeDataEntry
			
		if ore:
			if tile_type == TileType.Type.ORE_BIOME:
				inventory.add_item(str(TileType.Type.keys()[tile_type]))
			else:
				inventory.add_items("CURRENCY", ore.currency_value)
	#elif placeable_type:
		
	_world.remove_cell(local_pos)
