extends Position2D

var zoom
var grid_size
var half_grid
var grid_modX = 64 * 2
var grid_modY = 64 * 1

onready var Player = $"../World/Player"
onready var Level = $"../World/Level"
onready var CameraStart = $"../World/CameraStart"
onready var ViewField = $"CameraViewField/Field"
onready var Camera = $"Camera2D"

func _ready():
#	print("View Port Size = ", get_viewport().size)
#	print("Real Window Size = ", OS.get_real_window_size())
	set_as_toplevel(true)
	zoom = Camera.zoom
	grid_size = get_viewport().size * zoom
	half_grid = grid_size/2
	position.x = CameraStart.position.x - half_grid.x
	position.y = CameraStart.position.y - grid_size.y + (32*9)
	ViewField.position.x = grid_size.x / 2
	ViewField.position.y = grid_size.y / 2
	print(grid_size)
	pass

func _on_Left_entered(body):
	if body == Player:
		position.x -= grid_size.x - grid_modX
		LevelGenerator.set_current_pos("left")
		Level.set_new_rooms()
	pass


func _on_Right_entered(body):
	if body == Player:
		position.x += grid_size.x - grid_modX
		LevelGenerator.set_current_pos("right")
		Level.set_new_rooms()
	pass


func _on_Bottom_entered(body):
	if body == Player:
		position.y += grid_size.y - grid_modY
		LevelGenerator.set_current_pos("down")
		Level.set_new_rooms()
	pass


func _on_Top_entered(body):
	if body == Player:
		position.y -= grid_size.y - grid_modY
		LevelGenerator.set_current_pos("up")
		Level.set_new_rooms()
	pass
