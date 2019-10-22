tool
extends TileMap

export var TILE_SIZE : Vector2 = Vector2(1,1) setget set_tile_size
export var TILE_C : int = 1 setget set_tile_c

const TYPE = "HexTileMap"

var M = 0

func _enter_tree() -> void:
	M = TILE_C/TILE_SIZE.x/2
	self.cell_y_sort = true
	self.cell_half_offset = TileMap.HALF_OFFSET_X

func set_tile_size(size):
	TILE_SIZE = size
	self.cell_size = TILE_SIZE - Vector2(0, TILE_C + 1)

func set_tile_c(c):
	TILE_C = c
	self.cell_size = TILE_SIZE - Vector2(0, TILE_C + 1)
	
func get_hex_center(hex : Vector2):
	return map_to_world(hex) + TILE_SIZE/2
	
func get_hex_neighbours(hex : Vector2):
	return {
		"NORTHEAST": hex + Vector2( 0.0, -1.0),
		"EAST": hex + Vector2( 1.0,  0.0),
		"SOUTHEAST": hex + Vector2( 0.0,  1.0),
		"SOUTHWEST": hex + Vector2(-1.0,  1.0),
		"WEST": hex + Vector2(-1.0,  0.0),
		"NORTHWEST": hex + Vector2(-1.0, -1.0)
	}
	
func world_to_map(world_pos):
	var world_pos_local = to_local(world_pos)
	var highlighted_cell = .world_to_map(world_pos_local)
	var relative_pos = world_pos_local - map_to_world(highlighted_cell)
	
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