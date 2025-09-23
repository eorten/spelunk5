class_name TerrainRenderer extends Node

@onready var bg_layer: TileMapLayer = %BGLayer
@onready var base_tile_layer: TileMapLayer = %BaseTileLayer
@onready var ore_layer: TileMapLayer = %OreLayer
@onready var placeable_layer: Node2D = %PlaceableLayer
var placeable_dict: Dictionary[Vector2i, Node2D]

#func get_world_cells() -> Dictionary[Vector2i, BiomeData.Types]:
func render(world_dict:Dictionary, world_placeable_dict:Dictionary[Vector2i, PlaceableTypes.Type], placeable_registry:Dictionary[PlaceableTypes.Type, PackedScene], biome_visuals:BiomeVisuals):
	for pos:Vector2i in world_dict.keys():
		bg_layer.set_cell(pos, 0, biome_visuals.get_entry(TileType.Type.BG).atlas_coords)
		re_render_cell(pos, 
			world_dict, 
			world_placeable_dict, 
			placeable_registry, 
			biome_visuals
		)

func re_render_cell(pos:Vector2i, world_dict:Dictionary, world_placeable_dict:Dictionary[Vector2i, PlaceableTypes.Type], placeable_registry:Dictionary[PlaceableTypes.Type, PackedScene], biome_visuals:BiomeVisuals):
	base_tile_layer.set_cell(pos)
	ore_layer.set_cell(pos)
	match world_dict[pos]:
		TileType.Type.BORDER:
			base_tile_layer.set_cell(pos, 0, biome_visuals.get_entry(TileType.Type.BORDER).atlas_coords)
		
		TileType.Type.AIR:
			if placeable_dict.get(pos, null):
				placeable_dict[pos].queue_free()
		
		TileType.Type.PLACEABLE:
			#remove old
			#if placeable_dict.get(pos, null):
				#placeable_dict[pos].queue_free()
				
			var placeable_type := world_placeable_dict.get(pos) as PlaceableTypes.Type
			var placeable_prefab := placeable_registry.get(placeable_type) as PackedScene
			var new_placeable := placeable_prefab.instantiate() as Node2D
			placeable_dict[pos] = new_placeable
			placeable_layer.add_child(new_placeable)
			new_placeable.global_position = World.cell_to_global(pos) #Wrong? 
			
		TileType.Type.DIRT:
			_place_dirt(pos,biome_visuals)
		
		TileType.Type.STONE:
			base_tile_layer.set_cell(pos, 0, biome_visuals.get_entry(TileType.Type.STONE).atlas_coords)
		
		TileType.Type.ORE_COMMON:
			_place_dirt(pos,biome_visuals)
			ore_layer.set_cell(pos, 0, biome_visuals.get_entry(TileType.Type.ORE_COMMON).atlas_coords)
		
		TileType.Type.ORE_UNCOMMON:
			_place_dirt(pos,biome_visuals)
			ore_layer.set_cell(pos, 0, biome_visuals.get_entry(TileType.Type.ORE_UNCOMMON).atlas_coords)
			
		TileType.Type.ORE_RARE:
			_place_dirt(pos,biome_visuals)
			ore_layer.set_cell(pos, 0, biome_visuals.get_entry(TileType.Type.ORE_RARE).atlas_coords)
			
		TileType.Type.ORE_BIOME:
			_place_dirt(pos,biome_visuals)
			ore_layer.set_cell(pos, 0, biome_visuals.get_entry(TileType.Type.ORE_BIOME).atlas_coords)
	
func _place_dirt(pos:Vector2, biome_visuals:BiomeVisuals):
	base_tile_layer.set_cell(pos, 0, biome_visuals.get_entry(TileType.Type.DIRT).atlas_coords)
