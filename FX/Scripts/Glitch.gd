extends Sprite

var animation = "Flare"

func _ready():
	pass

func play():
	$AnimatedSprite.play(animation)
	pass

func set_animation(var new_anim):
	animation = new_anim
	pass