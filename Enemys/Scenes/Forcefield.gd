extends Particles2D

func _ready():
	pass

func emit():
	set_emitting(true)
	$AnimationPlayer.play("field_grow")
	pass
