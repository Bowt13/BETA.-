extends Node2D

var state = false

export (int, 1, 100) var walk_spd = 1

var max_spd
onready var Movement = $'../../../MovementHandler'

func _ready():
	walk_spd *= 100
	pass

func _physics_process(delta):
	pass

func enter():
	if !$"../Dashing".state:
		state = true
		Movement.set_max_speed(walk_spd)
		Movement.set_glide_multiplier(0.7)
		print(self.name, ' entered')
	pass

func exit():
	state = false
	print(self.name, ' exited')
	pass