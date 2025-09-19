class_name TerrainGenerator extends RefCounted

## Base biome: Biome with global ores
var _base_biome_data:BiomeData
func _init(base_biome_data:BiomeData) -> void:
	_base_biome_data = base_biome_data 

## Biome: Biome with unique ores and terrrain
func create_terrain(size:int, biome:BiomeData) -> Dictionary[Vector2i, TileType.Type]:
	
	#region Terrain grids
	var border_grid = BitMap.new()
	border_grid.create(Vector2i(size, size))
	border_grid = GridUtils.add_border(border_grid, 1)
	var dirt_grid = biome.get_entry(TileType.Type.DIRT).get_grid(size) as BitMap
	dirt_grid = GridUtils.add_border(dirt_grid)
	dirt_grid = GridUtils.cellular_atoma(dirt_grid, 5)
	var stone_grid := biome.get_entry(TileType.Type.STONE).get_grid(size) as BitMap
	#endregion
	
	#region Ore grids
	var common_ore_grid := _base_biome_data.get_entry(TileType.Type.ORE_COMMON).get_grid(size) as BitMap
	var uncommon_ore_grid := _base_biome_data.get_entry(TileType.Type.ORE_UNCOMMON).get_grid(size) as BitMap
	var rare_ore_grid := _base_biome_data.get_entry(TileType.Type.ORE_RARE).get_grid(size) as BitMap
	var biome_ore = biome.get_entry(TileType.Type.ORE_BIOME)
	
	#Set grid if there exits biome ore
	var biome_ore_grid:BitMap
	if biome_ore:
		biome_ore_grid = biome.get_entry(TileType.Type.ORE_BIOME).get_grid(size) as BitMap
	#endregion
	
	var res:Dictionary[Vector2i, TileType.Type] = {}
	for y in size:
		#var r:String = ""
		for x in size:
			var pos := Vector2i(x,y) as Vector2i
			var pos_type:TileType.Type
			if border_grid.get_bit(x,y):
				pos_type = TileType.Type.BORDER
			elif !dirt_grid.get_bit(x,y): #air
				pos_type = TileType.Type.AIR 
			elif biome_ore and biome_ore_grid.get_bit(x,y): #biome ore
				pos_type = TileType.Type.ORE_BIOME
			elif stone_grid.get_bit(x,y): #Stone
				pos_type = TileType.Type.STONE
			elif rare_ore_grid.get_bit(x,y): #rare ore
				pos_type = TileType.Type.ORE_RARE
			elif uncommon_ore_grid.get_bit(x,y): #uncommon ore
				pos_type = TileType.Type.ORE_UNCOMMON
			elif common_ore_grid.get_bit(x,y): #common ore
				pos_type = TileType.Type.ORE_COMMON
			else: #dirt
				pos_type = TileType.Type.DIRT
			res[pos] = pos_type
			#r+=str(pos_type)
		#print(r)
	
	return res
