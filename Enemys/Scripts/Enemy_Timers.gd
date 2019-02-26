extends Node2D

func _ready():
	pass

func is_hit_start():
	$Inv_timer.start()
	$Hit_timer.start()
	pass

func search_start():
	$Search_timer.start()
	pass

func jump_start():
	$Jump_timer.start()
	pass
	
func piose_regain_start():
	$Piose_timer.start()
	pass