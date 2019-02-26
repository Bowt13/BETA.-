extends Node2D

var state = false
onready var Movement = $"../../MovementHandler"

export (int, 1, 50) var jump_height

func _ready():
	jump_height *= 100
	jump_height = -jump_height
	pass

func enter(on_off):
	state = true
	if(on_off == 'on'):
		Movement.jump(jump_height)
	print(self.name, ' entered')
	pass

func exit():
	state = false
	print(self.name, ' exited')
	pass