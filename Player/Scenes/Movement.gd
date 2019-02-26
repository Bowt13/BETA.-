extends Node2D

onready var World = $'/root/Game/World'
onready var Player = World.get_node("Player")

#PHYSICS
var Physics

#MOVEMENT
var motion = Vector2(0, 0)
var max_speed = 1800
var speed_fw
var speed_bw
var collision_multiplier = 1
var jump_speed = -2000
var looking_left
var looking_right
var Glide_Multiplier = 0.7

const knockback = Vector2(1000, -1400)

signal is_on_ground
export (int, 1, 10) var accel_spd = 1

var dir
var current_dir

var max_spd
var abs_spd
var abs_max_spd

var airborn = [false, false]

func _ready():
	accel_spd *= 100
	motion.x = 1
	pass

func _on_Player_share_Physics(new_Physics):
	Physics = new_Physics
	pass

func _physics_process(delta):
	if Physics.size() > 0:
		set_speed(delta)
		assign_gravity(delta)
		move_player()
	pass

func set_max_speed(new_max_spd_fw):
	max_spd = new_max_spd_fw
	abs_max_spd= abs(max_spd)
	pass

func set_direction(new_dir):
	dir = new_dir
	pass

func set_glide_multiplier(new_ratio):
	Glide_Multiplier = new_ratio
	pass

func set_speed(delta):
	if !Player.get_node("StatesHandler/Move/Dashing").state:
		var abs_spd = abs(motion.x)
		if abs_max_spd:
			if dir:
				if dir == 0:
					motion.x *= get_glide(abs_spd)
				if abs_max_spd > abs_spd and current_dir != dir:
					motion.x += accel_spd * dir * delta
					current_dir = dir
				else:
					motion.x = abs_max_spd * dir
			else:
				if Player.is_on_wall():
					motion.x = 0
				if false in airborn:
					motion.x *= get_glide(abs_spd)
				else:
					motion.x
		Player.get_node("Body").change_anim_speed(motion.x)
	pass

func get_glide(abs_spd):
	var motion_var  = (abs_max_spd - abs_spd) + 1
	return( ( (Physics.Glide_Ratio + Glide_Multiplier) / 2 ) )
	pass

func dash(new_motion):
	motion = new_motion
	pass

func jump(height):
	if false in airborn:
		motion.y = height
	pass

func set_gravity(new_gravity):
	if World:
		World.set_gravity(new_gravity)
	pass

func set_max_gravity(new_max_gravity):
	if World:
		World.set_max_gravity(new_max_gravity)
	pass

func assign_gravity(delta):
	if Player.is_on_ceiling():
		motion.y = 1
	else:
		if motion.y < Physics.Max_Gravity:
			motion.y += Physics.Gravity
		else:
			motion.y = Physics.Max_Gravity
	pass

func move_player():
	Player.move_and_slide(motion, Physics.Up, 100, 100)
	pass

func _if_on_ground( position, value):
	if position == 'Ground_ray1':
		airborn.pop_front()
		airborn.insert( 0, !value )
	if position == 'Ground_ray2':
		airborn.pop_back()
		airborn.insert( 1, !value )
	pass

