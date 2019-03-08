extends Node

# SETTINGS
var print_error = true
var print_grid = true

var is_initialized = false

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
			"L"	: 	0,
			"R"	: 	0,
			"U"	: 	0,
			"D"	: 	0
		}
	}

### TEMPLATES
var path
var saveName = "ROOM_TEMPLATES"
var ROOM_TEMPLATES_DIC
var room_templates = []
var room_template = {
		"pos"		:	Vector2(0, 0),
		"template"	:	{
			"RoomType" : {
				"L"	: 	0,
				"R"	: 	0,
				"U"	: 	0,
				"D"	: 	0
			},
			"RoomCells" : [],
		}
	}

#FUNCTIONS
func _init():
	randomize()
	path = "res://Saves/"+saveName+".json"
	load_templates()
	pass

func _ready():
	set_start_room()
	pass

## PRINTER
func print_error(error):
	if print_error:
		print("res://Library/LevelGenerator.gd")
		print("Error: ", error)
	pass

func print_rooms(var value):
	if value != "all":
		for room in rooms:
			print(room[value])
	else:
		for room in rooms:
			print(room)
	pass

## PLAYER
func set_current_pos(var direction):
	room = init_room_template()
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
	for room in rooms:
		print(room.pos, current_pos)
		print(room.pos == current_pos)
		if room.pos == current_pos:
			print("CJECL")
			set_rooms_around(room)
			set_room_templates()
	pass

## ROOMS
func init_room_template():
	var x = {
	"start"	:	false,
	"end"	:	false,
	"pos"	:	Vector2(0,0),
	"type"	: 	{
			"L"	: 	0,
			"R"	: 	0,
			"U"	: 	0,
			"D"	: 	0
		}
	}
	return(x)
	pass

## LEVEL GENERATOR
func set_start_room():
	room.start = true
	room.type = get_type(room)
	rooms.push_front(room.duplicate())
	set_rooms_around(room)
	set_room_templates()
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
			if used_room.type["D"] != 0:
				U = used_room.type["D"]
			else:
				U = -1
		if	used_room.pos == down_pos:
			if used_room.type["U"] != 0:
				D = used_room.type["U"]
			else:
				D = -1
		# HORIZONTAL
		if	used_room.pos == left_pos:
			if used_room.type["R"] != 0:
				L = used_room.type["R"]
			else:
				L = -1
		if	used_room.pos == right_pos:
			if used_room.type["L"] != 0:
				R = used_room.type["L"]
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
			"L"	: 	L,
			"R"	: 	R,
			"U"	: 	U,
			"D"	: 	D
		}
	var check = 0
	for value in type.values():
		check += value
	if check <= 1:
		print_error("not enough openings in room")
		return(get_type(room))
	else:
		return(type)
	pass

func set_rooms_around(var room):
	for direction in room.type.keys():
		if room.type[direction] == 1:
			var temp_room = init_room_template()
			match direction:
				"L":
					temp_room.pos.x -= 1
				"R":
					temp_room.pos.x += 1
				"U":
					temp_room.pos.y -= 1
				"D":
					temp_room.pos.y += 1
			temp_room.type = get_type(temp_room)
			rooms.push_back(temp_room.duplicate())
	pass

func load_templates():
	ROOM_TEMPLATES_DIC = RoomTemplate.load_json(path)
	pass

func set_room_templates():
	var types = []
	for x in range(ROOM_TEMPLATES_DIC.Rooms.size()):
		var r_temp = ROOM_TEMPLATES_DIC.Rooms[x]
		var r_temp_name = "Room_"+str(x+1)+""
		var r_temp_type = r_temp[r_temp_name].RoomType
		var sum = 0
		for value in r_temp[r_temp_name].RoomType.values():
			if value > 1:
				sum -= value
			else:
				sum += value
		if sum > 0:
			for room in rooms:
				var checker = 0
				for key in room.type.keys():
					key = str(key)
					if room.type[key] == r_temp_type[key]:
						checker += 1
				if checker == 4:
					var r_temp__ = room_template.duplicate()
					r_temp__.pos = room.pos
					r_temp__.template = r_temp[r_temp_name]
					room_templates.push_back(r_temp__)
					continue
					pass
	pass

func get_room_templates():
	return(room_templates)
	pass