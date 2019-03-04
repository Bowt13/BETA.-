extends Node

# SETTINGS
var print_error = true
var print_grid = true

# PLAYER
## POSITION
var current_pos = Vector2(0, 0)

# LEVEL
## GRID


## ROOMS
var rooms = []
var room = {
		"start"	:	false,
		"end"	:	false,
		"pos"	:	Vector2(0,0),
		"type"	: 	{
				"U"	: 	0,
				"R"	: 	0,
				"D"	: 	0,
				"L"	: 	0
			}
	}

#FUNCTIONS
func _ready():
	randomize()
	set_start_room()
	pass

## PRINTER
func print_error(error):
	if print_error:
		print("res://Library/LevelGenerator.gd")
		print("Error: ", error)
	pass

## PLAYER
func set_current_pos(var direction):
	match direction:
		"left":
			current_pos.x -= 1
		"right":
			current_pos.x += 1
		"up":
			current_pos.y -= 1
		"down":
			current_pos.y += 1
	#check if rooms arround are 
	pass

## ROOMS
func init_room_template():
	room = {
		"start"	:	false,
		"end"	:	false,
		"pos"	:	Vector2(0,0),
		"type"	: 	{
			"U"	: 	0,
			"D"	: 	0,
			"L"	: 	0,
			"R"	: 	0
			}
	}
	pass

## LEVEL GENERATOR
func set_start_room():
	room.start = true
	room.type = get_type(room)
	rooms.push_front(room)
	print(rooms)
	pass

func get_type(var room):
	"""
	Figure out the Room Type
	"""
	# VERTICAL
	## UP
	var up_pos 		= Vector2(room.pos.x, room.pos.y - 1)
	var U = 0
	## DOWN
	var down_pos 	= Vector2(room.pos.x, room.pos.y + 1)
	var D = 0
	# HORIZONTAL
	## LEFT
	var right_pos 	= Vector2(room.pos.x + 1, room.pos.y)
	var L = 0
	## RIGHT
	var left_pos 	= Vector2(room.pos.x - 1, room.pos.y)
	var R = 0

	"""
	Check if the Current room has rooms round it.
	And if so check if they have an exit on a side.
	"""
	for used_room in rooms:
		# VERTICAL
		if	used_room.pos == up_pos:
			if used_room.type[D] != 0:
				U = used_room.type[D]
			else:
				U = -1
		if	used_room.pos == down_pos:
			if used_room.type[U] != 0:
				D = used_room.type[U]
			else:
				D = -1
		# HORIZONTAL
		if	used_room.pos == left_pos:
			if used_room.type[R] != 0:
				L = used_room.type[R]
			else:
				L = -1
		if	used_room.pos == right_pos:
			if used_room.type[L] != 0:
				R = used_room.type[L]
			else:
				R = -1

	# VERTICAL
	## UP
	if U == 0:
		U = randi()%2
	elif U == -1:
		U = 0
	## DOWN
	if D == 0:
		D = randi()%2
	elif D == -1:
		D = 0
	# HORIZONTAL
	## LEFT
	if L == 0:
		L = randi()%2
	elif L == -1:
		L = 0
	## RIGHT
	if R == 0:
		R = randi()%2
	elif R == -1:
		L = 0

	var type	= 	{
			"U"	: 	U,
			"D"	: 	D,
			"L"	: 	L,
			"R"	: 	R
		}
	return(type)
	pass