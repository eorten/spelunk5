class_name MiningSystem extends RefCounted
## Mediator
var _world:World
func _init(world:World) -> void:
	_world = world

func try_mine_at(global_pos:Vector2i , inventory:Inventory):
	var local_pos = World.global_to_cell(global_pos)
	
	if _world.cell_exists(local_pos):
		var tile_type:TileType.Type = _world._world_cells[local_pos]
		var ore = null
		if _world.get_biome_data().biome_dict.has(tile_type):
			ore = _world.get_biome_data().get_entry(tile_type) as BiomeDataEntry
		
		if ore:
			inventory.add_items("currency", ore.currency_value)
		_world.remove_cell(local_pos)
