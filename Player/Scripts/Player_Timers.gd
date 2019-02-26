extends Node2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func is_hit_start():
	$Inv_timer.start()
	$Hit_timer.start()
	pass
	
func ghost_start():
	$Ghost_timer.start()
	pass
	