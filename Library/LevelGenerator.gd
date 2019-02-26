extends Node

var will_print = true

var grid_size
var level_grid
var start_percentage_grid = []
var end_percentage_grid

var grid
var init_grid = false
var print_grid

# RECURSION CHECKER
var rec_counter = 0
var rec_amount = 5

var start_room
var end_room

var path = []

var current_room_pos

func _ready():
	randomize()
	pass

func print_error(error):
	if will_print:
		print("res://Library/LevelGenerator.gd")
		print("Error: ", error)
	pass

func print_grid():
	grid = flip_grid()
	print(" ")
	for row in range(grid.size()):
		print(grid[row])
	print(" ")

	print_grid = grid
	pass

func flip_grid():
	var new_grid = []
	for y in range(level_grid[0].size()):
		new_grid.push_back([])
		for x in range(level_grid.size()):
			new_grid[y].push_back(0)

	new_grid[start_room.pos.y][start_room.pos.x] = 1
	var dif = end_room.pos - start_room.pos
	new_grid[end_room.pos.y][end_room.pos.x] = abs(dif.y) + abs(dif.x) + 1
	return(new_grid)
	pass

func create_grid(Width,Height):
	var level = []
	print_grid = []
	for x in range(Width):
		print_grid.push_back([])
		level.push_back([])
		for y in range(Height):
			print_grid[x].push_back(0)
			var room = {
				"type": "",
				"pos": Vector2(x,y),
				"start": false,
				"end": false,
				"path": false
				}
			level[x].push_back(room)
	level_grid = level
	generate_level()
	pass

func set_gridsize(new_grid_size):
	grid_size = new_grid_size
	pass

func generate_level():
	set_start_room()
	set_end_room()
	create_path()
	pass

func set_start_room():
	start_percentage_grid = get_percentage_grid("start")
	set_rooms("start", start_percentage_grid)
	pass

func set_end_room():
	end_percentage_grid = get_percentage_grid("end")
	set_rooms("end", end_percentage_grid)
	pass

func get_percentage_grid(var type):
	var percentage_grid = []
	var level_grid_size = float(level_grid.size())
	var percentage_increment = 100.0/ ( ( (level_grid_size - 1) * (level_grid_size)) / 2.0)
	for x in range(level_grid_size):
		var rooms_per_column = level_grid[x].size()
		var column_array = []
		for y in range(rooms_per_column):
			var rooms_percentage = (percentage_increment*x)*(1.0/rooms_per_column)
			column_array.push_front(stepify(rooms_percentage, 0.01))
		if type  == "start":
			percentage_grid.push_back(column_array)
		elif type == "end":
			percentage_grid.push_front(column_array)
		pass
	return(percentage_grid)
	pass

func set_rooms(var type, grid):
	var col = get_column(grid)
	var rand = int(rand_range(0.0, float(grid[col].size())))
	if type == "start":
		var room = level_grid[col][rand]
		room.start = true
		insert_room(col, rand, room)
	elif type == "end":
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

func insert_room(var column, var row, room):
	level_grid[column].remove(row)
	level_grid[column].insert(row, room)
	if room.start:
		start_room = room
	elif room.end:
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
	current_room_pos = Vector2(start_room.pos.x,start_room.pos.y)
	start_room.type = get_room_type(start_room)
	end_room.type = get_room_type(start_room)
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

	for key in room.type.keys():
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
	pass

func set_path(var current_room):
	if current_room.start:
		path.push_front(current_room)
	while current_room.pos != end_room.pos:
		var picked_opening = get_picked_opening(current_room)
		match picked_opening:
			"L_O":
				current_room.pos.x -= 1
			"R_O":
				current_room.pos.x += 1
			"T_O":
				current_room.pos.y -= 1
			"B_O":
				current_room.pos.y += 1

		if !current_room.end:
			current_room = level_grid[current_room.pos.x][current_room.pos.y]
			current_room.path = true
			current_room.type = get_room_type(current_room)
			path.push_back(current_room)
			level_grid[current_room.pos.x].remove(current_room.pos.y)
			level_grid[current_room.pos.x].insert(current_room.pos.y, current_room)
	print(start_room.pos)
	print(end_room.pos)
	print_grid()
	check()
	pass

func check():
	for column in level_grid:
		for room in column:
			if room.start:
				print("START")
			elif room.end:
				print("END")
			elif room.path:
				print("PATH")