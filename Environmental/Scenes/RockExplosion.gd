extends Particles2D

func explode():
	
	self.set_emitting(true)
	$PebbleExplosion.set_emitting(true)
	$PebbleExplosion2.set_emitting(true)
	pass

func _on_Kill_timer_timeout():
	queue_free()
	pass
