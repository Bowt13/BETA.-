extends Node2D

var state = false

func _ready():
	pass

func enter(on_off):
	state = true
	print(self.name, ' entered')
	pass

func exit():
	state = false
	print(self.name, ' exited')
	pass