extends Node2D

var previous_lifetime = 1
onready var Gun = $"../"

func _physics_process(delta):
	if delta != delta:
		print(delta)
	check_lifetime()
	global_position = Gun.get_node("GunAiming/GunRotator/Sprite/BarrelEnd").global_position
	pass
	
func check_lifetime():
	if Gun.get_node('States').smoking():
		for child in $Particles.get_children():
			if child.lifetime > 2.5:
				previous_lifetime = -1
			if child.lifetime < 1:
				previous_lifetime = 1
			child.lifetime += 0.025*previous_lifetime*rand_range(1,11)
			child.speed_scale = rand_range(0.1,1)
			child.emitting = true
	else:
		for child in $Particles.get_children():
			child.emitting = false
		pass
	pass

func shot_fired():

	pass