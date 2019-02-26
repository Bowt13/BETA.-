extends Node2D

export(PackedScene) var Gun_scene

var guns = []
var aiming_Sprite
var holster_Sprite
var crosshair_Sprite
var aiming
var dual_wielding = false
onready var Aiming = $'../StatesHandler/Aiming'
onready var Holder = $'..'

func _ready():
	var Gun_Inst = Gun_scene.instance()
	add_child(Gun_Inst)
	guns.push_front(Gun_Inst)
	pass

func _physics_process(delta):
	if Aiming.state:
		aiming = true
	else:
		aiming = false
		position_gun_holster()

	pass

func has_guns():
	var gunsarr = [false, false]
	for child in guns:
		if "Gun" in child.name:
			gunsarr.push_front(true)
			gunsarr.pop_back()
	return(gunsarr)
	pass

func get_gun(Gun_scene):
	var Gun_Inst = Gun_scene.instance()
	if guns.size() == 1:
		$Dual_timer.wait_time = guns[0].get_node("Gun_timers/ShootSpeed_timer").wait_time
		$Dual_timer.wait_time *= 0.5
	add_child(Gun_Inst)
	guns.push_front(Gun_Inst)
	if guns.size() > 2:
		guns.pop_last()
	position_gun_holster()
	draw_gun()
	pass

func draw_gun():
	if has_guns().has(true):
		if Aiming.state:
			for child in guns:
				child.get_node('GunAiming/GunRotator/Sprite').show()
				child.get_node('GunHolster/Sprite').hide()
				if guns.size() == 1:
					child.get_node('GunAiming/CrosshairRotator/Sprite').show()
				else:
					guns[0].get_node('GunAiming/CrosshairRotator/Sprite').show()
					guns[1].get_node('GunAiming/GunRotator/Sprite').z_index = -1

		else:
			for child in guns:
				child.get_node('GunAiming/GunRotator/Sprite').hide()
				child.get_node('GunAiming/CrosshairRotator/Sprite').hide()
				child.get_node('GunHolster/Sprite').show()
	pass
	
func position_gun_holster():
	if has_guns().has(true):
		if Holder.get_node('Body/Sprite').is_flipped_h():
			for child in guns:
				child.get_node('GunHolster/Sprite').set_flip_h(true)
				child.get_node('GunHolster/Sprite').set_position(Vector2(6, child.get_node('GunHolster/Sprite').get_position().y))
				if guns.size() == 1:
					child.get_node('GunHolster/Sprite').z_index = 0
				else:
					guns[0].get_node('GunHolster/Sprite').z_index = 0
					guns[0].get_node('GunHolster/Sprite').set_modulate(Color(0.4, 0.4, 0.4))
					guns[1].get_node('GunHolster/Sprite').z_index = 5
					guns[1].get_node('GunHolster/Sprite').set_modulate(Color(1, 1, 1))
#					guns[1].get_node('GunAiming/GunRotator/Sprite').position = Vector2(-5, -5)
		else:
			for child in guns:
				child.get_node('GunHolster/Sprite').set_flip_h(false)
				child.get_node('GunHolster/Sprite').set_position(Vector2(-6, child.get_node('GunHolster/Sprite').get_position().y))
				if guns.size() == 1:
					child.get_node('GunHolster/Sprite').z_index = 5
				else:
					guns[0].get_node('GunHolster/Sprite').z_index = 5
					guns[0].get_node('GunHolster/Sprite').set_modulate(Color(1, 1, 1))
					guns[1].get_node('GunHolster/Sprite').z_index = 0
					guns[1].get_node('GunHolster/Sprite').set_modulate(Color(0.4, 0.4, 0.4))
	pass
	
func pull_trigger():

	pass

func _pull_trigger():
	var counter = 0
	if true in has_guns():
		guns[0].shoot(Holder.get_node("PlayerPos").position)
		if guns.size() > 1 and !dual_wielding and $Dual_timer.get_time_left() == 0:
			$Dual_timer.start()
		elif guns.size() > 1 and dual_wielding:
			guns[1].shoot(Holder.get_node("PlayerPos").position)
	pass


func _on_Dual_timer_timeout():
	dual_wielding = true
	pass


func _on_release_trigger():
	dual_wielding = false
	$Dual_timer.stop()
	pass
