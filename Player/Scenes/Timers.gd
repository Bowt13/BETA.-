extends Node2D

func _ready():

	pass

#func _process(delta):

#	pass

func set_shoot_speed(time):
	$ShootSpeed_timer.set_wait_time(time)
	pass

func set_reload_speed(time):
	$ReloadSpeed_timer.set_wait_time(time)
	pass

func ghost_start():
	$Ghost_timer.start()
	pass