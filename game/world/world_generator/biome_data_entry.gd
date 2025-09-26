class_name BiomeDataEntry extends Resource
@export var map:FastNoiseLite
@export var threshold:float = 0
@export var currency_value:int = 0

func get_grid(grid_size:int) -> BitMap:
	map.seed = randf() * 9999
	var res := BitMap.new()
	res.create(Vector2i(grid_size,grid_size))
	for x in grid_size:
		for y in grid_size:
			res.set_bit(x, y, map.get_noise_2d(x,y)>threshold)
	return res
