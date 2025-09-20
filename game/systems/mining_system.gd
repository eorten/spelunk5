class_name MiningSystem extends RefCounted

var _world:World
func _init(world:World) -> void:
	_world = world

func try_mine_at(global_pos:Vector2i): #, player:PlayerData)
	print("try mine at global pos ", global_pos)
	var local_pos = World.global_to_cell(global_pos)
	print("try mine at local pos ", local_pos)
	
	if _world.cell_exists(local_pos):
		print("Mined at pos ", local_pos)
		_world.remove_cell(local_pos)
	else:
		print("World has no tile at ", local_pos)

#func mine(tile: Tile, tool: Tool, robot: Robot):
	#tile.apply_damage(tool.get_damage())
	#if tile.is_broken():
		#MiningSystem.spawn_drop(tile.resource)
		#robot.consume_energy(tool.energy_cost)
