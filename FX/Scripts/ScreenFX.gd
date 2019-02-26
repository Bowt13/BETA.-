extends Node2D

func _ready():
	$Glitch3.play()
	pass

func _on_FX_timer_timeout():
	play_FX()
	pass

func _on_LensFlare_animation_finished():
	stop_FX()
	pass

func play_FX():
	$LensFlare.play("Flare")
	$LensFlare._set_playing(true)
	pass
	
func stop_FX():
	reset()
	$FX_timer.start()
	pass

func reset():
	randomize()
	$LensFlare.stop()
	$LensFlare._set_playing(false)
	$LensFlare.set_frame(0);
	$FX_timer.stop()
	$FX_timer.set_wait_time(rand_range(1.0, 10.0))
	pass