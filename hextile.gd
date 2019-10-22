tool
extends Sprite

export var AUTO_NAVIGATION : bool = false setget set_auto_navigation
export var AUTO_COLLISION : bool = false setget set_auto_collision

const TYPE = 'HexTile'

var HexTileSet

func _enter_tree() -> void:
	self.centered = false
	self.HexTileSet = get_parent()

func _get_configuration_warning():
	if get_parent().TYPE != "HexTileSet":
		return 'HexTile must be a child to HexTileSet'
	return ''
	
func get_hexagon():
	
	var size = HexTileSet.SIZE
	var c = HexTileSet.C
	
	var TOP_LEFT = Vector2(0, c)
	var TOP = Vector2(size.x/2, 0)
	var TOP_RIGHT = Vector2(size.x, c)
	var BOTTOM_RIGHT = Vector2(size.x, size.y - c)
	var BOTTOM = Vector2(size.x/2, size.y)
	var BOTTOM_LEFT = Vector2(0, size.y - c)
	
	# To connect the navigation polygons we must subtract 1 pixel from the bottom
	BOTTOM.y -= 1
	BOTTOM_RIGHT.y -= 1
	BOTTOM_LEFT.y -= 1
	
	return PoolVector2Array([
		TOP_LEFT,
		TOP,
		TOP_RIGHT,
		BOTTOM_RIGHT,
		BOTTOM,
		BOTTOM_LEFT
	])

func set_auto_navigation(auto_navigation : bool):
	
	if Engine.editor_hint and HexTileSet:
		
		if not auto_navigation and has_node("AutoNavigation"):
			remove_child($AutoNavigation)
			
		if auto_navigation and not has_node("AutoNavigation"):
			var navpolyinstance = NavigationPolygonInstance.new()
			navpolyinstance.name = "AutoNavigation"
			var navpoly = NavigationPolygon.new()
			
			var hexagon = get_hexagon()
			
			navpoly.add_outline(hexagon)
			
			navpoly.make_polygons_from_outlines()
			navpolyinstance.navpoly = navpoly
			add_child(navpolyinstance)
			navpolyinstance.set_owner(get_tree().get_edited_scene_root())
	
	AUTO_NAVIGATION = auto_navigation
	
func set_auto_collision(auto_collisionshape : bool):

	if Engine.editor_hint and HexTileSet:
		
		if not auto_collisionshape and has_node("AutoCollision"):
			remove_child($AutoCollision)
			
		if auto_collisionshape and not has_node("AutoCollision"):
			var staticbody = StaticBody2D.new()
			staticbody.name = "AutoCollision"
			
			var colpoly = CollisionPolygon2D.new()
			colpoly.polygon = get_hexagon()
			
			staticbody.add_child(colpoly)
			
			add_child(staticbody)
			staticbody.set_owner(get_tree().get_edited_scene_root())
	
	AUTO_COLLISION = auto_collisionshape