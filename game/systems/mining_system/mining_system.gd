class_name MiningSystem extends RefCounted
## Mediator
var _world:World
var _world_root:Node2D
var _mine_animation_prefab:PackedScene
func _init(world:World, world_root:Node2D, mine_animation_prefab:PackedScene) -> void:
	_world = world
	_world_root = world_root
	_mine_animation_prefab = mine_animation_prefab
	mining = false

func _mine_at(global_pos:Vector2i, inventory:Inventory):
	
	var local_pos = World.global_to_cell(global_pos)
	
	var tile_type:TileType.Type = _world._world_cells.get(local_pos, TileType.Type.AIR)
	#var placeable_type:PlaceableTypes.Type = _world._world_placeables.get(local_pos, PlaceableTypes.Type.EMPTY)
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

func can_mine_at(global_pos:Vector2i) -> bool:
	var local_pos = World.global_to_cell(global_pos)
	if !_world.cell_exists(local_pos): return false;
	return true

var mining:bool
var current_inv:Inventory
var current_mine_anim:Node2D
var mining_pos:Vector2i
var current_mine_timer:float
func start_mine(global_pos:Vector2i, mine_time:float, inventory:Inventory):
	mining = true
	current_mine_timer = mine_time
	current_inv = inventory
	mining_pos = global_pos
	current_mine_anim = _mine_animation_prefab.instantiate()
	current_mine_anim.global_position = World.snap_pos_to_grid(global_pos)
	_world_root.add_child(current_mine_anim)
	current_mine_anim.play_anim(mine_time)

func interrupt_mine():
	if !mining:return;
	if !current_mine_anim:return;
	current_mine_anim.queue_free()
	mining = false
	

func tick(delta:float):
	if !mining:return;
	current_mine_timer -= delta
	if current_mine_timer <= 0:
		_mine_at(mining_pos, current_inv)
		mining = false
		
