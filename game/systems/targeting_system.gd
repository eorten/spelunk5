class_name TargetingSystem extends RefCounted

#@export_flags_2d_physics var raycast_collision_mask
var _raycast_collision_mask:int
var _world:World
var _world_root:Node2D
func _init(world_root:Node2D, world:World, raycast_collision_mask:int) -> void:
	_world_root = world_root
	_world = world
	_raycast_collision_mask = raycast_collision_mask

var _tile_empty:bool = false
var _tile_pos:Vector2
func get_targeted_pos() -> Vector2:
	return _tile_pos

#func tick(origin_world_pos:Vector2i, target_world_pos:Vector2i, range:int): #player pos, mouse pos
	##target_world_pos = (Vector2(target_world_pos) - Vector2(origin_world_pos)).normalized() * range #ADD RANGE
	#var cast_res = _cast_result(origin_world_pos, target_world_pos)
	#if cast_res.get("collider"): #If ray hit
		#var hit_tile_pos = cast_res.get("position") - cast_res.get("normal")
		#_tile_empty = false
		#_tile_pos = hit_tile_pos
	#else: #If ray didnt hit anything
		#_tile_empty = true
		#_tile_pos =target_world_pos

func tick(origin_world_pos:Vector2, target_world_pos:Vector2, targeting_range:int): #player pos, mouse pos
	var dir:Vector2 = target_world_pos - origin_world_pos
	if dir.length() > targeting_range:
		target_world_pos = (dir.normalized() * targeting_range) + origin_world_pos
	
	#target_world_pos = (Vector2(target_world_pos) - Vector2(origin_world_pos)).normalized() * targeting_range #ADD RANGE
	var cast_res = _cast_result(origin_world_pos, target_world_pos)

	if cast_res.get("collider"): #If ray hit
		var hit_tile_pos = cast_res.get("position") - cast_res.get("normal")
		_tile_empty = false
		_tile_pos = World.snap_pos_to_grid_offset(hit_tile_pos) 
	else: #If ray didnt hit anything
		_tile_empty = true
		_tile_pos = World.snap_pos_to_grid_offset(target_world_pos)

func can_destroy_targeted() -> bool:
	return !_tile_empty

func can_place_targeted() -> bool:
	return _tile_empty

func _cast_result(origin_world_pos:Vector2, target_world_pos:Vector2) -> Dictionary:
	var space_state = _world_root.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(origin_world_pos, target_world_pos, _raycast_collision_mask)
	return space_state.intersect_ray(query)
