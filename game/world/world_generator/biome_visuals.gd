class_name BiomeVisuals extends Resource
@export var biome_dict:Dictionary[TileType.Type, BiomeVisualEntry]

func get_entry(type:TileType.Type):
	return biome_dict.get(type)
