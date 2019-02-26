extends Node2D

var state = false

onready var GunHandler = $'../../GunHandler'

func _ready():
	pass

func enter():
	state = true
	GunHandler.draw_gun()
	print(self.name, ' entered')
	pass

func exit():
	state = false
	GunHandler.draw_gun()
	print(self.name, ' exited')
	pass