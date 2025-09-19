class_name GridUtils extends Node

const _neighbours = [
		Vector2(1,1),
		Vector2(1,0),
		Vector2(1,-1),
		Vector2(0,1),
		Vector2(0,0),
		Vector2(0,-1),
		Vector2(-1,1),
		Vector2(-1,0),
		Vector2(-1,-1),
	]

## Adds an inside border of size "border_size" to the bitmap "grid"
static func add_border(grid:BitMap, border_size:int = 3, border_fill:bool = true) -> BitMap:
	var grid_size := grid.get_size() as Vector2i
	var new_grid := BitMap.new()
	new_grid.create(grid_size)

	for x in grid_size.x:
		for y in grid_size.y:
			var is_border := (
				x < border_size
				or y < border_size
				or x >= grid_size.x - border_size
				or y >= grid_size.y - border_size
			) as bool

			if is_border:
				new_grid.set_bit(x, y, border_fill)
			else:
				new_grid.set_bit(x, y, grid.get_bit(x, y))

	return new_grid

## Runs the cellular automate algirithm to smooth the bitmap "grid" "smoothness" times
static func cellular_atoma(grid:BitMap, smoothness:int = 1):
	for x in smoothness:
		grid = _cellular_atoma(grid)
	return grid

static func _cellular_atoma(grid:BitMap):
	var grid_size = grid.get_size() as Vector2i
	var new_array := BitMap.new()
	new_array.create(grid_size)
	
	for x in grid_size.x:
		for y in grid_size.y:
			var cur_pos = Vector2(x,y)
			var neighbour_count:float = 0.0
			for pos in _neighbours:
				var check_pos = cur_pos + pos
				if check_pos.x < 0 or check_pos.x > grid_size.x-1 or check_pos.y < 0 or check_pos.y > grid_size.y-1: #Out of bounds
					neighbour_count += 0.5
					continue;
				neighbour_count += int(grid.get_bit(check_pos.x,check_pos.y))	
			new_array.set_bit(x, y, neighbour_count > 4.0)
	return new_array
