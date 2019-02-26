extends Node2D

func _ready():

	pass

func start_shot_speed():
	$ShootSpeed_timer.start()
	pass

func set_shoot_speed(time):
	$ShootSpeed_timer.set_wait_time(time)
	pass

func set_reload_speed(time):
	$ReloadSpeed_timer.set_wait_time(time)
	pass
	
func start_recoil_speed():
	$Recoil_timer.start()
	pass

func ghost_start():
	$Ghost_timer.start()
	pass