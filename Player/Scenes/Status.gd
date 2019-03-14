extends Node2D

var state = false
var current_status

func _ready():
	pass

func _physics_process(delta):
	if delta != delta:
		print(delta)
	if state == true:
		pass
	pass

func enter(status):
	state = true
	current_status = status
	print(self.name, ' entered')
	pass

func exit():
	state = false
	print(self.name, ' exited')
	pass