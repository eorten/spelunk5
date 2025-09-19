class_name TerrainElement extends Resource
enum Type{DIRT, STONE, ORE, BG}
@export var id:String
@export var type:Type
@export var atlas_coords:Vector2i
@export var map:FastNoiseLite
@export var threshold:float = 0

func is_at_pos(x:int, y:int):
	return map.get_noise_2d(x, y) > threshold
