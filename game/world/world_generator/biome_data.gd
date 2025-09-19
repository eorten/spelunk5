class_name BiomeData extends Resource

## Add: Biome dirt, biome stone, biome ore
@export var biome_dict:Dictionary[TileType.Type, BiomeDataEntry]

func get_entry(type:TileType.Type):
	return biome_dict.get(type)
