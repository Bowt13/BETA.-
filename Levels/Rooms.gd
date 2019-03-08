extends Node2D

onready var Background	= $Background
onready var Foreground	= $Foreground
onready var Spawners	= $Spawners

func init(new_layout):
	var offset = 0
## GENERATE POSITION
	if new_layout.has("pos"):
		offset = get_room_offset(new_layout)

## GENERATE BACKGROUND
	if new_layout.has("Background"):
		for position in new_layout.Background:
			var new_pos = $Background/Wall.map_to_world(position)
			new_pos.x += offset.x
			new_pos.y += offset.y
			new_pos = $Background/Wall.world_to_map(new_pos)
			$Background/Wall.set_cellv(new_pos, 0)
## GENERATE FOREGROUND
	if new_layout.has("Foreground"):
	## GENERATE WALL
		for position in new_layout.Foreground:
			var pos_arr = position.replace("(", "").replace(")", "").split(",")
			var pos = Vector2(pos_arr[0], pos_arr[1])
			var new_pos = $Foreground/Wall.map_to_world(pos)
			new_pos.x += offset.x
			new_pos.y += offset.y
			new_pos = $Foreground/Wall.world_to_map(new_pos)
			$Foreground/Wall.set_cellv(new_pos, 0)
		
	## GENERATE DESTRUCTABLE WALL
		$Foreground/DestructableWall.clear()
	pass

func get_room_offset(new_layout):
## GET OFFSET ROOMS
	print(new_layout.pos)
	var offset = Vector2(new_layout.pos.x * (1920-128), new_layout.pos.y * (960-64))
	return(offset)
	pass

func get_room_global_pos():
	var cells_pos_global = []
	for cell in $Foreground/Wall.get_used_cells():
		cells_pos_global.push_front($Foreground/Wall.map_to_world(cell))
	return(cells_pos_global)
	queue_free()
	pass

func autotile_all(Node):
	for child in Node.get_children():
		if child.is_class("TileMap"):
			child.update_bitmask_region()
		if child.get_children().size() > 0:
			autotile_all(child)
	pass