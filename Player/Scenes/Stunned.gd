extends Node2D

var state = false

export (int, 1, 20) var stun_dur

func _ready():
	stun_dur *= 100
	pass

func enter():
	state = true
	print(self.name, ' entered')
	pass

func exit():
	state = false
	print(self.name, ' exited')
	pass