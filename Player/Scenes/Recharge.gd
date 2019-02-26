extends Node2D

var state = false

func _ready():
	pass

func enter():
	state = true
	pass

func exit():
	state = false
	pass

func _on_Wait_timer_timeout():
	enter()
	pass
