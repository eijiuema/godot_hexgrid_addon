tool
extends Node

export var SIZE : Vector2 setget set_size
export var C : int setget set_c

const TYPE = "HexTileSet"

func set_size(size):
	SIZE = size
	update_children()
	
func set_c(c):
	C = c
	update_children()
	
func update_children():
	for child in get_children():
		if child.TYPE == 'HexTile':
			if child.AUTO_NAVIGATION:
				child.AUTO_NAVIGATION = false
				child.AUTO_NAVIGATION = true
			if child.AUTO_COLLISION:
				child.AUTO_COLLISION = false
				child.AUTO_COLLISION = true