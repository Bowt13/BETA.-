extends Sprite

var opacity = 0.1
var time = 0.2

func _process(delta):
	pass

func set_tween(new_opacity, new_time):
	opacity = new_opacity
	time = new_time
	$AlphaTween.interpolate_property(self, "modulate", Color( 1, 1, 1, opacity), Color( 1, 1, 1, 0), time, Tween.TRANS_SINE, Tween.EASE_IN)
	pass

func start():
	$AlphaTween.start()
	pass

func _on_AlphaTween_tween_completed(object, key):
	queue_free()
	pass
