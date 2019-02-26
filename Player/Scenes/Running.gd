extends Node2D

var state = false

export (int, 1, 20) var run_spd = 1

onready var Movement = $'../../../MovementHandler'

func _ready():
	run_spd *= 100
	pass

func enter():
	state = true
	Movement.set_max_speed(run_spd)
	print(self.name, ' entered')
	pass

func exit():
	state = false
	print(self.name, ' exited')
	pass