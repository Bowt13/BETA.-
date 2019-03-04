extends Node

# SETTINGS
var print_error = true
var print_grid = true

# PLAYER
## POSITION
var current_pos = Vector2(0, 0)

# LEVEL
## GRID
var level_grid
var room_amount = 0
var start_percentage_grid = []
var end_percentage_grid = []

var grid
var init_grid = false

## ROOMS
var start_room
var end_room
var path = []
var current_room_pos
var start_room_counter = 0
var end_room_counter = 0

# RECURSION CHECKER
var rec_counter = 0
var rec_amount = 5

#FUNCTIONS
func _ready():
	randomize()
	pass

## PRINTER
func print_error(error):
	if print_error:
		print("res://Library/LevelGenerator.gd")
		print("Error: ", error)
	pass

func print_grid():
	# displays grid in simple form
	if print_grid:
		grid = flip_grid()
		print(" ")
		for row in range(grid.size()):
			print(grid[row])
		print(" ")
	pass

func flip_grid():
	# simplefies, flips the grid 90ﬁdeg and returns it
	var new_grid = []
	for y in range(level_grid[0].size()):
		new_grid.push_back([])
		for x in range(level_grid.size()):
			new_grid[y].push_back(0)

	new_grid[start_room.pos.y][start_room.pos.x] = 1
	var dif = end_room.pos - start_room.pos
	dif = abs(dif.y) + abs(dif.x) + 1
	for room in path:
		if room.start:
			new_grid[room.pos.y][room.pos.x] = 1
		elif room.end:
			new_grid[room.pos.y][room.pos.x] = dif
		else:
			new_grid[room.pos.y][room.pos.x] = "!"
	return(new_grid)
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

## LEVEL GENERATOR
func create_grid(Width,Height):
	# create grid with empty rooms
	var level = []
	for x in range(Width):
		level.push_back([])
		for y in range(Height):
			# get empty room template
			var room = get_empty_room(x, y)
			# fill grid with empty rooms
			level[x].push_back(room)
			room_amount += 1
	# set level to grid
	level_grid = level
	# start assign rooms to level
	generate_level()
	pass

func get_empty_room(var x, var y):
	# returns empty room template
	var room = {
		"type": {},
		"pos": Vector2(x,y),
		"start": false,
		"end": false,
		"path": false,
		"placed": false
		}
	return(room)
	pass

func generate_level():
	# all steps needed to generate level
	# set start room
#	set_start_room()
	# set end room
#	set_end_room()
	# create path between start & end
#	create_path()
	pass

func set_start_room():
	# finds start room position and sets it
	
	# get the chance percentages per room for start room
	start_percentage_grid = get_percentage_grid("start")
	# set the start room to the correct position
	set_rooms("start", start_percentage_grid)
	pass

func set_end_room():
	# finds end room position and sets it
	
	# get the chance percentages per room for end room
	end_percentage_grid = get_percentage_grid("end")
	# set the end room to the correct position
	set_rooms("end", end_percentage_grid)
	pass

func get_percentage_grid(var type):
	# find the correct chance percentage per room for certain room
	# put it in a grid and return it
	
	# generate grid
	var percentage_grid = []
	var level_grid_width = float(level_grid.size())
	# calculate percentage change per column
	var percentage_increment = 100.0/ ( ( (level_grid_width - 1) * (level_grid_width)) / 2.0)
	# fill room percentage chances
	for x in range(level_grid_width):
		# set amount of rooms per column
		var rooms_per_column = level_grid[x].size()
		var column_array = []
		# distribute column percentage over rooms
		for y in range(rooms_per_column):
			var rooms_percentage = (percentage_increment*x)*(1.0/rooms_per_column)
			column_array.push_front(stepify(rooms_percentage, 0.01))
		if type  == "start":
			# greatest chance on the "left" of the level
			percentage_grid.push_back(column_array)
		elif type == "end":
			# greatest chance on the "right" of the level
			percentage_grid.push_front(column_array)
		pass
	return(percentage_grid)
	pass

func set_rooms(var type, grid):
	var col = get_column(grid)
	var rand = int(rand_range(0.0, float(grid[col].size())))
	if type == "start" and !level_has("start"):
		var room = level_grid[col][rand]
		room.start = true
		insert_room(col, rand, room)
	elif type == "end" and !level_has("end"):
		rec_counter += 1
		var room = level_grid[col][rand]
		if room.pos.x == start_room.pos.x or room.pos.x + 1 == start_room.pos.x or room.pos.x - 1 == start_room.pos.x:
			if rec_counter < rec_amount:
				print_error("end colomn is to close to start column")
				set_rooms("end", grid)
			else:
				if room.pos.x == start_room.pos.x:
					print_error("end colomn is the start column")
					set_rooms("end", grid)
				else:
					room.pos = Vector2(col, rand)
					room.end = true
					insert_room(col, rand, room)
		elif room.pos.y == start_room.pos.y or room.pos.y + 1 == start_room.pos.y or room.pos.y - 1 == start_room.pos.y:
			if rec_counter < rec_amount and room.pos.y != start_room.pos.y:
				print_error("end row is to close to start row")
				set_rooms("end", grid)
			else:
				room.pos = Vector2(col, rand)
				room.end = true
				insert_room(col, rand, room)
		else:
			room.pos = Vector2(col, rand)
			room.end = true
			insert_room(col, rand, room)
	pass

func level_has(var type):
	var counter = 0
	for column in level_grid:
		for room in column:
			if room[type]:
				counter += 1
	print( type, " rooms: ",counter)
	if counter > 0:
		return(true)
	else:
		return(false)
	pass

func insert_room(var column, var row, room):
	level_grid[column].remove(row)
	level_grid[column].insert(row, room)
	if room.start:
		start_room_counter += 1
		start_room = room
	elif room.end:
		end_room_counter += 1
		end_room = room
	rec_counter = 0
	pass

func get_column(var array_2d):
	var rand = int(rand_range(0.0, 100.0))
	for col in range(array_2d.size()):
		var column_chance = 0
		for room_perc in array_2d[col]:
			column_chance += room_perc
		if rand >= column_chance:
			return(col)
	pass

func create_path():
	# Creates a Path between 2 rooms

	# 1.	Set start room type
	# 2.	Pick an opening from start room
	# 3.	Get 1st path room
	# 4.	Find a 2nd path room must be viable
	# 5.	Set 1st path room type
	# 6.	Repeat step 4 & 5 until end room
	# 7.	Find a room with a free opening
	# 8.	Set room as new start room
	# 9.	Find a room with a free opening, if no free openings find open grid pos
	# 10.	Set room as new end room
	# 11.	if path can't be created between start & end rooms repeat step 9
	# 12.	Repeat step 7 => 11 until no more empty 
	
	"""
	1. pick start room
	2. set room type
	3. Generate surrounding rooms
	4. Set surrounding room types
	"""
	current_room_pos = Vector2(start_room.pos.x,start_room.pos.y)
	start_room.type = get_room_type(start_room)
	end_room.type = get_room_type(end_room)
	## START
	set_path(start_room)
	
	## END
	var end_opening = []
	var end_opening_amount = 0
	for key in end_room.type.keys():
		if end_room.type[key] == 1:
			end_opening_amount += 1
	pass

func get_room_type(var room):
	var openings
	# DECLARE
	## HORIZONTAL
	var L_O
	var R_O
	## VERTICAL
	var T_O
	var B_O

	var column_amount = level_grid.size()-1
	var row_amount = level_grid[0].size()-1
	
	# ASSIGN
	## HORIZONTAL
	### LEFT
	if room.pos.x == 0:
		L_O	= 0
	elif room.start and room.pos.x - 1 == end_room.pos.x:
		L_O		= 0
	elif room.end and room.pos.x - 1 == start_room.pos.x:
		L_O		= 0
	else:
		L_O	= int(rand_range(0.0, 2.0))

	### RIGHT
	if room.pos.x == column_amount:
		R_O	= 0
	elif room.start and room.pos.x + 1 == end_room.pos.x:
		R_O		= 0
	elif room.end and room.pos.x + 1 == start_room.pos.x:
		R_O		= 0
	else:
		R_O	= int(rand_range(0.0, 2.0))

	## VERTICAL
	### TOP
	if room.pos.y == 0:
		T_O		= 0
	elif room.start and room.pos.y + 1 == end_room.pos.y:
		T_O		= 0
	elif room.end and room.pos.y + 1 == start_room.pos.y:
		T_O		= 0
	else:
		T_O		= int(rand_range(0.0, 2.0))

	### BOTTOM
	if room.pos.y == row_amount:
		B_O	= 0
	elif room.start and room.pos.y - 1 == end_room.pos.y:
		B_O		= 0
	elif room.end and room.pos.y - 1 == start_room.pos.y:
		B_O		= 0
	else:
		B_O	= int(rand_range(0.0, 2.0))


	var check = [L_O, R_O, T_O, B_O]
	var check_sum = 0
	for x in check:
		if x == 1:
			check_sum += 1
	if room.start or room.end:
		if check_sum >= 1:
			openings = (""+ str(L_O) +"_"+ str(R_O) +"_"+ str(T_O) +"_"+ str(B_O) +"")
			check = {
				"L_O": L_O,
				"R_O": R_O,
				"T_O": T_O,
				"B_O": B_O
				}
			return(check)
		else:
			return(get_room_type(room))
	elif room.path:
		if check_sum >= 2:
			openings = (""+ str(L_O) +"_"+ str(R_O) +"_"+ str(T_O) +"_"+ str(B_O) +"")
			check = {
				"L_O": L_O,
				"R_O": R_O,
				"T_O": T_O,
				"B_O": B_O
				}
			return(check)
		else:
			return(get_room_type(room))
	pass

func has_connecting_path(var current_room):
	var sum = 0
	for room in path:
		if current_room.pos.x + 1 == room.pos.x:
			sum += 1
		if current_room.pos.x - 1 == room.pos.x:
			sum += 1
		if current_room.pos.y + 1 == room.pos.y:
			sum += 1
		if current_room.pos.y - 1 == room.pos.y:
			sum += 1
	if sum > 0:
		return(true)
	else:
		return(false)
	pass

func get_picked_opening(var room):
	var openings = []
	var opening_amount = 0
	var picked_opening
	print(room)
	var type = room.type
	if typeof(type) == TYPE_DICTIONARY:
		for key in type.keys():
			if room.type[key] == 1:
				opening_amount += 1
				openings.push_back(key)
		picked_opening = int(rand_range(1.0, float(opening_amount)))
		var future_pos = room.pos
		match picked_opening:
			"L_O":
				future_pos.x -= 1
			"R_O":
				future_pos.x += 1
			"T_O":
				future_pos.y -= 1
			"B_O":
				future_pos.y += 1
		return(openings[picked_opening-1])
	else:
		print_error("WRONG TYPE")
	pass

func set_path(var current_room):
	while current_room.pos != end_room.pos:
		current_room.path = false
		if current_room.start:
			current_room.type = start_room.type
			path.push_front(current_room)
		elif current_room.end:
			current_room.type = end_room.type
			path.push_back(current_room)
		else:
			current_room.type = get_room_type(current_room)
			current_room.path = true
			path.insert(1, current_room)
			insert_room(current_room.pos.x, current_room.pos.y, current_room)

		current_room = get_next_room(current_room)

	print(start_room.pos)
	print(end_room.pos)
	print_grid()
	check()
	pass

func get_next_room(var current_room):
	var next_room = current_room
	var picked_opening = get_picked_opening(current_room)
	match picked_opening:
		"L_O":
			next_room.pos.x -= 1
		"R_O":
			next_room.pos.x += 1
		"T_O":
			next_room.pos.y -= 1
		"B_O":
			next_room.pos.y += 1
	return(next_room)
	pass

func check():
	var start = 0
	var path = 0
	var end = 0
	for column in level_grid:
		for room in column:
			if room.start:
				start += 1
				print("START")
			elif room.end:
				end += 1
				print("END")
			elif room.path:
				path += 1
				print("PATH")
	print ("start rooms: ", start)
	print (start_room_counter)
	print ("path rooms: ", path)
	print ("end rooms: ", end)
	pass