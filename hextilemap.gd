tool
extends TileMap

export var TILE_SIZE : Vector2 = Vector2(1,1) setget set_tile_size
export var TILE_C : int = 1 setget set_tile_c

const TYPE = "HexTileMap"

var M = 0

func _enter_tree() -> void:
	M = TILE_C/(TILE_SIZE.x/2)
	self.cell_y_sort = true
	self.cell_half_offset = TileMap.HALF_OFFSET_X

func set_tile_size(size):
	TILE_SIZE = size
	self.cell_size = TILE_SIZE - Vector2(0, TILE_C + 1)

func set_tile_c(c):
	TILE_C = c
	self.cell_size = TILE_SIZE - Vector2(0, TILE_C + 1)
	
func map_to_world(hex : Vector2, ignore_half_ofs : bool = false):
	return .map_to_world(hex, ignore_half_ofs) + TILE_SIZE/2
	
func get_hex_neighbours(hex : Vector2):
	
	if fmod(hex.y, 2) == 0:
		return {
			"NORTHEAST": hex + Vector2( 0.0, -1.0),
			"EAST": hex + Vector2( 1.0,  0.0),
			"SOUTHEAST": hex + Vector2( 0.0,  1.0),
			"SOUTHWEST": hex + Vector2(-1.0,  1.0),
			"WEST": hex + Vector2(-1.0,  0.0),
			"NORTHWEST": hex + Vector2(-1.0, -1.0)
		}
	else:
		return {
			"NORTHEAST": hex + Vector2( 1.0, -1.0),
			"EAST": hex + Vector2( 1.0,  0.0),
			"SOUTHEAST": hex + Vector2( 1.0,  1.0),
			"SOUTHWEST": hex + Vector2(0.0,  1.0),
			"WEST": hex + Vector2(-1.0,  0.0),
			"NORTHWEST": hex + Vector2(0.0, -1.0)
		}
		
func get_ring(center: Vector2, radius: int):
	
	if radius == 0:
		return [center]
	
	var ring = []
	var current_hex: Vector2 = center
	
	for i in range (0, radius):
		current_hex = get_hex_neighbours(current_hex).NORTHWEST
		
	ring.append(current_hex)
	
	for i in range(0, radius):
		current_hex = get_hex_neighbours(current_hex).EAST
		ring.append(current_hex)
		
	for i in range(0, radius):
		current_hex = get_hex_neighbours(current_hex).SOUTHEAST
		ring.append(current_hex)
		
	for i in range(0, radius):
		current_hex = get_hex_neighbours(current_hex).SOUTHWEST
		ring.append(current_hex)
		
	for i in range(0, radius):
		current_hex = get_hex_neighbours(current_hex).WEST
		ring.append(current_hex)
		
	for i in range(0, radius):
		current_hex = get_hex_neighbours(current_hex).NORTHWEST
		ring.append(current_hex)
		
	for i in range(0, radius):
		current_hex = get_hex_neighbours(current_hex).NORTHEAST
		ring.append(current_hex)
		
	return ring
	
func get_circle(center: Vector2, radius: int):
	var circle = []
	for x in range(0, radius):
		circle += get_ring(center, x)
	return circle
	
func world_to_map(world_pos):
	var world_pos_local = to_local(world_pos)
	var highlighted_cell = .world_to_map(world_pos_local)
	var relative_pos = world_pos_local - .map_to_world(highlighted_cell)
	
	if relative_pos.x < TILE_SIZE.x/2:
		if -M*relative_pos.x + TILE_C - relative_pos.y >= 1:
			if fmod(highlighted_cell.y, 2) == 0:
				highlighted_cell += Vector2(-1, -1)
			else:
				highlighted_cell += Vector2(0, -1)
	else:
		if M*relative_pos.x - TILE_C - relative_pos.y >= 1:
			if fmod(highlighted_cell.y, 2) == 0:
				highlighted_cell += Vector2(0, -1)
			else:
				highlighted_cell += Vector2(1, -1)
				
	return highlighted_cell