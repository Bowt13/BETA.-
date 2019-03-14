extends Control

var grid_position
var grid_size
var half_grid

onready var Player = $'/root/Game/World/Player'
onready var GridSnapper = $'/root/Game/GridSnapper'

func _ready():
	$PlayerLifebar._initialize(Player)
	grid_position = GridSnapper.position
	grid_size = OS.get_real_window_size()
	grid_size.y = grid_size.y - 22
	half_grid = grid_size/2
	rect_size = grid_size
	pass