extends Node2D

signal share_Physics

var Room_Resource = preload("res://Levels/RoomResource/RoomResource.gd")
var Room_Type

var rest_rooms = 0

var rooms_Right = 1
var rooms_Left = 1
var rooms_Top = 0
var rooms_Bottom = 0

var current_rooms = []

func _ready():
	set_fog_size()
	spawn_rooms()
	pass

func set_fog_size():
	var Fog = $Fog
	var Fog_rect = Fog.region_rect

## SET FOG_X_MOD
	var fog_x_mod
	if rooms_Right > rooms_Left:
		fog_x_mod = get_fog_mod(rooms_Right)
	else:
		fog_x_mod = get_fog_mod(rooms_Left)

## SET FOG_Y_MOD
	var fog_y_mod
	if rooms_Top > rooms_Bottom:
		fog_y_mod = get_fog_mod(rooms_Top)
	else:
		fog_y_mod = get_fog_mod(rooms_Bottom)

	Fog_rect.size.x *= fog_x_mod
	Fog_rect.size.y *= fog_y_mod
	Fog.set_region_rect(Rect2(Fog_rect.position, Fog_rect.size))
	pass

func get_fog_mod(value):
	var x = (value * 2) + 1
	return(x)
	pass

func spawn_rooms():
	Room_Type = Room_Resource.new()
	## GENERATE ROOMS TO THE RIGHT
	for x in range(rooms_Right):
		var new_layout
		var is_last_R = false
		if x == rooms_Right - 1:
			is_last_R = true
		if is_last_R:
			new_layout = {
				room_number = x+1,
				room_side = "R",
				Background = 0,
				Foreground = Room_Type['_1_0_0_0']['room_1'].Foreground,
				Spawners = 0,
				is_last = true
				}
		else:
			new_layout = {
				room_number = x+1,
				room_side = "R",
				Background = 0,
				Foreground = Room_Type['_1_1_0_0']['room_1'].Foreground,
				Spawners = 0,
				is_last = false
				}
		$Rooms.init(new_layout)

## GENERATE ROOMS TO THE LEFT
	for x in range(rooms_Left):
		var new_layout
		var is_last_L = false
		if x == rooms_Left - 1:
			is_last_L = true
		if is_last_L:
			new_layout = {
				room_number = x+1,
				room_side = "L",
				Background = 0,
				Foreground = Room_Type['_0_1_0_0']['room_1'].Foreground,
				Spawners = 0,
				is_last = true
				}
		else:
			new_layout = {
				room_number = x+1,
				room_side = "L",
				Background = 0,
				Foreground = Room_Type['_1_1_0_0']['room_1'].Foreground,
				Spawners = 0,
				is_last = false
				}
		$Rooms.init(new_layout)
		for pos in $Rooms.get_room_global_pos():
			$Rooms/Foreground/Wall.set_cellv($Rooms/Foreground/Wall.world_to_map(pos), 0)
	$Rooms.autotile_all($Rooms)
	pass

func autotile(TileMap):
	TileMap.update_bitmask_region()
	pass

func _on_World_share_Physics(new_Physics):

	pass