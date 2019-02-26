extends Node2D

var state

func _ready():
	pass

func _physics_process(delta):
	pass
	
func enter():
	state = true
	print(self.name, ' entered')
	pass

func exit():
	state = false
	print(self.name, ' exited')
	pass