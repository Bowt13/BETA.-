extends Node2D

var state = false
onready var Delay = $Delay_timer
export (int, 1, 20) var inv_dur

func _ready():
	inv_dur *= 100
	pass

func enter():
	state = true
	print(self.name, ' entered')
	pass

func exit():
	Delay.start()
	pass
	
func hard_exit():
	state = false
	print(self.name, ' exited')
	pass

func _on_Delay_timer_timeout():
	hard_exit()
	pass
