class_name MiningSystem extends Node

#func try_mine_at(pos:Vector2i, world:World)

#func mine(tile: Tile, tool: Tool, robot: Robot):
	#tile.apply_damage(tool.get_damage())
	#if tile.is_broken():
		#MiningSystem.spawn_drop(tile.resource)
		#robot.consume_energy(tool.energy_cost)
