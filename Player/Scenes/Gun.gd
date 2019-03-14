extends Node2D

onready var Globals = $'/root/Game'.Globals

#OWNER
var Owner

#HANDLER
var Handler
var handler_pos
var aiming_right
var aiming_left

#GUN
var gun_type
var gun_damage
var gun_shot_speed
var gun_spread
var gun_bullet_amount
var gun_clip_size
var gun_reload_speed

var barrel_pos
var crosshair_pos

#GUNTYPES
var pstl = "pistol"
var pstl_damage = 10
var pstl_speed = 0.5
var pstl_spread = 0
var pstl_bullet_amount = 1
var pstl_clip_size = 9
var pstl_reload_speed = 1

#BULLET
export(PackedScene) var bullet_scene
var this_bullet
var bullet_speed = 50

#CONDITIONALS
var is_chambering = false

func _ready():
	gun_type = pstl
	get_handler()
	get_owner()
	set_holstered_gun()
	pass

func _physics_process(delta):
	if delta != delta:
		print(delta)
	set_gun_type()
	aim_gun()
	pass

func get_handler():
	Handler = $'..'
	handler_pos = Handler.global_position
	pass

func get_owner():
	Owner = Handler.get_parent()
	pass

func change_gun_type():
	match gun_type:
		pstl:
			gun_type = pstl
	pass

func barrel_free_check():
	var bodies = $GunAiming/GunRotator/Sprite/BarrelEnd/Area2D.get_overlapping_bodies()
	for body in bodies:
		if "Wall" in body.name:
			return false
	return true
	pass

func set_gun_type():
	match gun_type:
		pstl:
			gun_damage			=	pstl_damage
			gun_shot_speed		=	pstl_speed
			gun_spread			=	pstl_spread
			gun_bullet_amount	=	pstl_bullet_amount
			gun_clip_size		=	pstl_clip_size
			gun_reload_speed	=	pstl_reload_speed
	
	$Gun_timers.set_shoot_speed(gun_shot_speed)
	$Gun_timers.set_reload_speed(gun_reload_speed)
	set_holstered_gun()
	pass

func set_holstered_gun():
	$GunHolster/Sprite.texture = $GunAiming/GunRotator/Sprite.texture
	pass

func aim_gun():
	$GunAiming.look_at(get_global_mouse_position())
	var crosshair_rot = $GunAiming.get_rotation()
	$GunAiming/CrosshairRotator.set_rotation(-crosshair_rot)
	set_direction()
	pass

func set_direction():
	get_handler()
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < handler_pos.x:
		aiming_right = false
		aiming_left = true
	else:
		aiming_right = true
		aiming_left = false
	if aiming_left:
		$GunAiming/GunRotator/Sprite.flip_h = true
		$GunAiming/GunRotator/Sprite/Position2D.position.x = -1
	else:
		$GunAiming/GunRotator/Sprite.flip_h = false
		$GunAiming/GunRotator/Sprite/Position2D.position.x = 9
	pass

func can_shoot():
	if Handler.aiming:
		if !is_chambering:
			return(true)
		else:
			return(false)
	else:
		return(false)
	pass

func shoot():
	if can_shoot():
		$Sounds/Shot.play()
		Globals.ScreenShaker.screen_shake(0.2, 5, 1)
		if barrel_free_check():
			this_bullet = bullet_scene.instance()
			this_bullet.set_shooter(Owner)
			barrel_pos = $GunAiming/GunRotator/Sprite/Position2D.global_position
			crosshair_pos = $GunAiming/CrosshairRotator/Sprite/Position2D.global_position
			.get_node("../../../BulletContainer").add_child(this_bullet)
			this_bullet.shoot(barrel_pos, crosshair_pos, bullet_speed, gun_damage, $GunAiming/GunRotator/Sprite.flip_h)
		chamber()
		$Gun_timers.start_recoil_speed()
		muzzle_flare()
		$Gun_timers.start_shot_speed()
		$Smoke.shot_fired()
	pass

func chamber():
	is_chambering = true
	var container = get_node("../../../CasingContainer")
	$GunAiming/GunRotator/Sprite/CasingEjector.eject_casing(container)

func muzzle_flare():
	if is_flipped():
		$GunAiming/GunRotator/Sprite/BarrelEnd/Sprite.offset.x = -11
	else:
		$GunAiming/GunRotator/Sprite/BarrelEnd/Sprite.offset.x = 1
	if $GunAiming/GunRotator/Sprite/BarrelEnd/Sprite.flip_h:
		$GunAiming/GunRotator/Sprite/BarrelEnd/Sprite.flip_h = false
	else:
		$GunAiming/GunRotator/Sprite/BarrelEnd/Sprite.flip_h = true
	$GunAiming/GunRotator/Sprite/BarrelEnd/Sprite.visible = true
	$Gun_timers/MuzzleFlare_timer.start()
	pass

func recoil():
	var recoil_anim = $GunAiming/GunRotator/Sprite/AnimationPlayer
	var anim
	if is_flipped():
		anim = "recoil_left"
		$GunAiming/GunRotator/Sprite/CasingEjector/Position2D.position.x = -11
	else:
		anim = "recoil_right"
		$GunAiming/GunRotator/Sprite/CasingEjector/Position2D.position.x = 15
	recoil_anim.set_speed_scale(6)
	recoil_anim.set_current_animation(anim)
	recoil_anim.play()
	pass

func _on_ShootSpeed_timer_timeout():
	is_chambering = false
	pass

func _on_MuzzleFlare_timer_timeout():
	$GunAiming/GunRotator/Sprite/BarrelEnd/Sprite.visible = false
	pass

func _on_Recoil_timer_timeout():
	recoil()
	pass

func is_flipped():
	if $GunAiming/GunRotator/Sprite.flip_h:
		return true
	return false
	pass

