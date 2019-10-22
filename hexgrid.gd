tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("HexTile", "Sprite", preload("hextile.gd"), preload("hextile.png"))
	add_custom_type("HexTileSet", "Node", preload("hextileset.gd"), preload("hextileset.png"))
	add_custom_type("HexTileMap", "TileMap", preload("hextilemap.gd"), preload("hextilemap.png"))
	pass
	
func _exit_tree() -> void:
	remove_custom_type("HexTile")
	remove_custom_type("HexTileSet")
	remove_custom_type("HexTileMap")
	pass