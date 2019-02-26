extends Node2D

onready var Background	= $Background
onready var Foreground	= $Foreground
onready var Spawners	= $Spawners

func init(new_layout):
	var offset = 0
## GENERATE POSITION
	if new_layout.has("room_number"):
		if new_layout.has("room_side"):
			offset = get_room_offset(new_layout)

## GENERATE BACKGROUND
	if new_layout.has("Background"):
		for position in new_layout.Background:
			var new_pos = $Background/Wall.map_to_world(position)
			new_pos.x += offset
			new_pos = $Background/Wall.world_to_map(new_pos)
			$Background/Wall.set_cellv(new_pos, 0)
## GENERATE FOREGROUND
	if new_layout.has("Foreground"):
	## GENERATE WALL
		for position in new_layout.Foreground:
			var new_pos = $Foreground/Wall.map_to_world(position)
			new_pos.x += offset.x
			new_pos = $Foreground/Wall.world_to_map(new_pos)
			$Foreground/Wall.set_cellv(new_pos, 0)
		
	## GENERATE DESTRUCTABLE WALL
		$Foreground/DestructableWall.clear()
	pass

func get_room_offset(new_layout):
	var offset
## GET OFFSEET FOR LEFT AND RIGHT ROOMS
	if new_layout.room_side == "R" or new_layout.room_side == "L":
		offset = Vector2(new_layout.room_number * 1792, 0)
	if new_layout.room_side == "R":
		return(offset)
	if new_layout.room_side == "L":
		if new_layout.is_last:
			offset.x -= 128
		return(-offset)
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