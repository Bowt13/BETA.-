extends Node2D

signal share_Physics

var Room_Type

var rest_rooms = 0

var rooms_Right = 1
var rooms_Left = 1
var rooms_Top = 0
var rooms_Bottom = 0

var current_rooms = []


func _ready():
	set_fog_size()
	current_rooms = LevelGenerator.get_room_templates()
	for room in current_rooms:
		spawn_rooms(room)
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

func spawn_rooms(var room):
	## GENERATE ROOMS TO THE RIGHT
	var new_layout = {
			pos = room.pos,
			Background = 0,
			Foreground = room.template.RoomCells,
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

func set_new_rooms():
	current_rooms = LevelGenerator.get_room_templates()
	for room in current_rooms:
		spawn_rooms(room)
	pass