extends Node2D

export (int, 10, 100) var dash_spd
export (int, 1, 3) var dash_amount
export (int, 1, 10) var time_regen
export (int, 1, 100) var shot_regen

signal dash_changed

var set_dash_amount

var state = false
var STOP = Vector2(0,-300)
var max_vec_spd
var vec_spd

var mouse_pos

onready var Dash_Timer		= $Dash/Timer
onready var Dash_Particles	= $Dash/Particles
onready var Dash_Anim		= $Dash/Anim

onready var Wait_timer		= $Recharge/Wait_timer

onready var Player			= $"../../../"
onready var Invincible		= $"../../Status/Invincible"
onready var Movement		= $"../../../MovementHandler"
onready var Player_pos		= $"../../../PlayerPos"

var is_charging = false

func _ready():
	dash_spd *= 100
	dash_amount *= 100
	set_dash_amount = dash_amount
	Dash_Anim.playback_speed *= Dash_Timer.wait_time
	$Aim.init()
	pass

func _physics_process(delta):
	mouse_pos = get_global_mouse_position()
	if !state and dash_amount >= 100 and is_charging == true:
		exit_charging()
		$Aim.cast_beam()
		pass
	if state:
		if Wait_timer.time_left > 0:
			$Recharge.exit()
		Movement.dash(vec_spd)
		Movement.set_glide_multiplier(1)
		Wait_timer.stop()
		Wait_timer.start()
	if $Recharge.state:
		if set_dash_amount <= dash_amount:
			$Recharge.exit()
	emit_signal("dash_changed", dash_amount)
	pass

func enter_charging():
	is_charging = true
	pass

func exit_charging():
	is_charging = false
	vec_spd = get_motion()
	pass

func get_dir():
	if vec_spd.x > 0:
		return(1)
	elif vec_spd.x < 0:
		return(-1)
	pass

func enter():
	is_charging = false
	if !state and dash_amount >= 100:
		$Aim.stop()
		state = true
		dash_amount -= 100
		Dash_Timer.start()
		Dash_Anim.play("Fade")
		Invincible.enter()
		print(self.name, ' entered')
	pass

func exit():
	if state:
		state = false
		Dash_Timer.stop()
		Dash_Anim.stop(true)
		Invincible.exit()
		print(self.name, ' exited')
	pass

func get_motion():
	var vec1 =  ($Aim/Rotator/Aim_pos.global_position - Player_pos.global_position).normalized()
	return(Vector2(vec1.x * dash_spd, vec1.y * dash_spd))
	pass

func emit():
	Particles.look_at(get_global_mouse_position())
	Particles.global_rotation_degrees += 180
	Particles.set_emitting(true)
	pass

func stop_emit():
	Particles.set_emitting(false)
	pass

func _on_Charge_timer_timeout():
	if $Recharge.state:
		dash_amount += time_regen
	pass

func enemy_hit():
	dash_amount += shot_regen
	if set_dash_amount < dash_amount:
		dash_amount = set_dash_amount
	pass