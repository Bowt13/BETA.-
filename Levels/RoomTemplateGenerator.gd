extends Node2D

const SAVE_PATH = "res://Levels/RoomResource/RoomResource.cfg"

var RoomResource = preload("res://Levels/RoomResource/RoomResource.gd")
var RoomResource_File = ConfigFile.new()

var saveName = "ROOM_TEMPLATES"
var RoomType = ""

var RoomName = 1
var TemplateName = ( "Room_"+str(RoomName)+ "")
var path
var RoomCells = []

## ROOM OPENINGS
var opening_counter
var L_O = 0
var R_O = 0
var T_O = 0
var B_O = 0
### LEFT
var l_opening_1	= [Vector2(-28, -15),Vector2(-28, -14),Vector2(-28, -13),Vector2(-28, -12)]
var l_opening_2	= [Vector2(-28, -19),Vector2(-28, -18),Vector2(-28, -17),Vector2(-28, -16)]
var l_opening_3	= [Vector2(-28, -23),Vector2(-28, -22),Vector2(-28, -21),Vector2(-28, -20)]
### RIGHT
var r_opening_1	= [Vector2(-1, -15),Vector2(-1, -14),Vector2(-1, -13),Vector2(-1, -12)]
var r_opening_2	= [Vector2(-1, -19),Vector2(-1, -18),Vector2(-1, -17),Vector2(-1, -16)]
var r_opening_3	= [Vector2(-1, -23),Vector2(-1, -22),Vector2(-1, -21),Vector2(-1, -20)]
### TOP
var t_opening_1	= [Vector2(-26, -24),Vector2(-25, -24),Vector2(-24, -24),Vector2(-23, -24),Vector2(-22, -24),Vector2(-21, -24),Vector2(-20, -24),Vector2(-19, -24)]
var t_opening_2	= [Vector2(-18, -24),Vector2(-17, -24),Vector2(-16, -24),Vector2(-15, -24),Vector2(-14, -24),Vector2(-13, -24),Vector2(-12, -24),Vector2(-11, -24)]
var t_opening_3	= [Vector2(-10, -24),Vector2(-9, -24),Vector2(-8, -24),Vector2(-7, -24),Vector2(-6, -24),Vector2(-5, -24),Vector2(-4, -24),Vector2(-3, -24)]
### BOTTOM
var b_opening_1	= [Vector2(-26, -11),Vector2(-25, -11),Vector2(-24, -11),Vector2(-23, -11),Vector2(-22, -11),Vector2(-21, -11),Vector2(-20, -11),Vector2(-19, -11)]
var b_opening_2	= [Vector2(-18, -11),Vector2(-17, -11),Vector2(-16, -11),Vector2(-15, -11),Vector2(-14, -11),Vector2(-13, -11),Vector2(-12, -11),Vector2(-11, -11)]
var b_opening_3	= [Vector2(-10, -11),Vector2(-9, -11),Vector2(-8, -11),Vector2(-7, -11),Vector2(-6, -11),Vector2(-5, -11),Vector2(-4, -11),Vector2(-3, -11)]

export(bool) var Save_on_Run = true
export(bool) var Reset_Rooms
var Load_on_Run = !Reset_Rooms

# declare our variables
var GameData = {
	"Rooms" : []
}

# initialize stuff here
func _ready():
	set_path()
	# first determine if a Saves directory exists.
	# if it doesn't, create it.
	var dir = Directory.new()
	if !dir.dir_exists("res://Saves"):
		dir.open("res://")
		dir.make_dir("res://Saves")
	if Load_on_Run:
		load_room()
	if Save_on_Run:
		save_room()
	pass

func get_gameData(var Template_Type, var Template_cells):
	var Template_Name = ( "Room_"+str(GameData.Rooms.size() + 1)+ "")
	var tempData = {
		Template_Name : {
			"RoomType" : Template_Type,
			"RoomCells" : Template_cells,
		}
	}
	if GameData.Rooms.size() > 0:
		var rooms = []
		for obj in GameData.Rooms:
			var key = obj.keys()[0]
			var room_dict = {
				key : obj[key]
			}
			rooms.push_back(room_dict)
		rooms.push_back({Template_Name : tempData[Template_Name]})
		GameData = {
			"Rooms" : rooms
		}
	else:
		GameData = {
			"Rooms" : [{Template_Name : tempData[Template_Name]}]
		}
	return(GameData)
	pass

func set_roomCells():
	RoomCells = $Foreground/Wall.get_used_cells()
	pass

func find_openings():
	## LEFT
	opening_counter = 0
	for opening in l_opening_1:
		if RoomCells.has(opening):
			opening_counter += 1
	if opening_counter == 0:
		L_O = 1
	opening_counter = 0
	for opening in l_opening_2:
		if RoomCells.has(opening):
			opening_counter += 1
	if opening_counter == 0:
		L_O = 2
	opening_counter = 0
	for opening in l_opening_3:
		if RoomCells.has(opening):
			opening_counter += 1
	if opening_counter == 0:
		L_O = 3
	
	## RIGHT
	opening_counter = 0
	for opening in r_opening_1:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		R_O = 1
	opening_counter = 0
	for opening in r_opening_2:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		R_O = 2
	opening_counter = 0
	for opening in r_opening_3:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		R_O = 3
	
	## TOP
	opening_counter = 0
	for opening in t_opening_1:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		T_O = 1
	opening_counter = 0
	for opening in t_opening_2:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		T_O = 2
	opening_counter = 0
	for opening in t_opening_3:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		T_O = 3
	
	## BOTTOM
	opening_counter = 0
	for opening in b_opening_1:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		B_O = 1
	opening_counter = 0
	for opening in b_opening_2:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		B_O = 2
	opening_counter = 0
	for opening in b_opening_3:
		if opening in RoomCells:
			opening_counter += 1
	if opening_counter == 0:
		B_O = 3
	pass

func set_path():
	path = "res://Saves/"+saveName+".json"
	pass

func set_roomType():
	find_openings()
	var type = (""+ str(L_O) +"_"+ str(R_O) +"_"+ str(T_O) +"_"+ str(B_O) +"")
	RoomType = type
	pass

func save_room():
	print("SAVING ...")
	set_roomCells()
	set_roomType()
	RoomTemplate.save_file(path, get_gameData(RoomType, RoomCells))
	get_tree().quit()
	pass

func load_room():
	print("LOADING ...")
	var my_json_object = RoomTemplate.load_json(path)
	GameData = my_json_object.result
	print("LOAD SUCCESSFUL")
	if !Save_on_Run:
		get_tree().quit()
	pass