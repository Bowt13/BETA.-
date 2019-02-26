extends KinematicBody2D

onready var Globals = $'/root/Game'.Globals

signal change_scale(new_scale)

export (float, 1.1, 20) var spawn_time = 1.1

#PLAYER
var player
var player_pos
var player_last_pos

var player_extents
var extent_tl
var extent_tr
var extent_bl
var extent_br

var player_side

#COLLISIONS
var bodies
var body_names = []

#SELF
var type = "REDIE"
var enemy_pos
var spawn_pos
var enemy_health = 50
var enemy_poise = 20
var current_poise = enemy_poise
var damage = 10
var jump
var jump_speed = -1400
const knockback = Vector2(400, -500)

#MOVEMENT
var move_speed = 32
var max_speed = 640
var motion = Vector2(0,0)

#GROW
var scale_1 = self.scale.x
var scale_2 = scale_1+(scale_1/3.0)+0.1
var scale_3 = scale_2+(scale_1/3.0)
var scale_4 = scale_3+(scale_1/3.0)

#PHYSICS
const UP = Vector2(0,-1)
const gravity = 100
const gravity_multiplier = 1.3
const normal_gravity = 100
const jump_gravity = normal_gravity * gravity_multiplier
const glide_ratio = 1.4

#CONDITIONALS
var can_jump = true
var is_hit = false


func _ready():
	$Health.initialize(enemy_health)
	spawn_pos = global_position
	spawn_time -= 1
	pass

func _physics_process(delta):
	get_pos()
	if player_is_in_viewfield():
		look_at_player()
	player_hit()
	if player_pos:
		set_motion_to_player(player_pos)
	elif player_last_pos:
		set_motion_to_player(player_last_pos)
	else:
		set_motion_loop()
	move()
	pass

func get_pos():
	enemy_pos = get_global_position()
	pass

func player_is_in_viewfield():
	for area in $ViewFieldContainer.get_overlapping_areas():
		if area.name == "CameraViewField":
			for body in area.get_overlapping_bodies():
				if body.name == "Player":
					player_extents = body.get_node("Body")
					player_extents = player_extents.shape
					player_extents = player_extents.get_extents()
					player_extents = player_extents * body.scale
					extent_tl = body.global_position - player_extents
					extent_tr = body.global_position + Vector2( -player_extents.x, player_extents.y) 
					extent_bl = body.global_position + Vector2( player_extents.x, -player_extents.y)
					extent_br = body.global_position + player_extents
					player_extents = [extent_tl, extent_bl, extent_br, extent_tr]
					return(true)
	pass

func look_at_player():
	for pos in player_extents:
		var Eye = preload("res://Enemys/Scripts/Eye.tscn").instance()
		$ViewFieldContainer.add_child(Eye)
		Eye.look_at(pos)
	pass

func player_spotted(position):
	player_pos = position
	player_last_pos = player_pos
	$Enemy_Timers.search_start()
	pass

func player_hit():
	bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			self.add_collision_exception_with(body)
			if body != self:
				if check_scale(body):
					var extra_health
					var extra_max_health
					body.queue_free()
					extra_health = body.get_node('Health').health
					extra_max_health = body.get_node('Health').max_health
					$Health.add_health(extra_health, extra_max_health)
		if body.has_method("hit_by_enemy"):
			body.hit_by_enemy(player_side, damage, self)
			if player_pos:
				if (player_pos.x > enemy_pos.x):
					get_knocked_back("right")
				elif (player_pos.x < enemy_pos.x):
					get_knocked_back("left")
			move()
	pass

func check_scale(body):
	if body.type == self.type:
		var other_scale = body.scale
		if other_scale <= self.scale:
			if self.scale.x == scale_1 and other_scale.x == scale_1:
				self.scale = Vector2( scale_2, scale_2)
				emit_signal("change_scale", self.scale)
				return(true)
			elif self.scale.x > scale_1 and self.scale.x < scale_2:
				if other_scale.x == scale_1:
					self.scale = Vector2( scale_3, scale_3)
					emit_signal("change_scale", self.scale)
					return(true)
				elif other_scale.x > scale_1 and other_scale.x < scale_2:
					self.scale = Vector2( scale_4, scale_4)
					emit_signal("change_scale", self.scale)
					return(true)
			#3+1
			elif self.scale.x > scale_2 and self.scale.x < scale_3:
				if other_scale.x == scale_1:
					self.scale = Vector2( scale_4, scale_4)
					emit_signal("change_scale", self.scale)
					return(true)
	pass

func set_motion_to_player(player_pos):
	if is_on_floor():
		if is_on_wall():
			if is_against_player():
					jump = true
			else:
				jump = false
		else:
			jump = false
		if can_jump:
			if jump:
				jump()
			else:
				gravity = normal_gravity
				motion.y = 0
	else:
		if motion.y > 0:
			gravity = jump_gravity
		motion.y += gravity
	if (player_pos.x - enemy_pos.x > 10):
		motion.x += move_speed
		player_side = "left"
	elif (player_pos.x - enemy_pos.x < -10):
		player_side = "right"
		motion.x += -move_speed
	else:
		if(player_pos.y - enemy_pos.y < 0) and (motion.x < 10) and (motion.x > -10):
			jump = true
		if(player_pos.y - enemy_pos.y > 0) and (motion.x < 10) and (motion.x > -10):
			motion.x = motion.x*10
		motion.x = (motion.x / glide_ratio)
	pass

func set_motion_loop():
	motion.x = (motion.x / glide_ratio)
	if is_on_floor():
	 motion.y = 0
	else:
		motion.y += gravity
	pass

func move():
	var abs_motion = abs(motion.x)
	var abs_max_spd = abs(max_speed)
	if abs_motion <= abs_max_spd:
		motion = move_and_slide(motion, UP)
	else:
		if motion.x < 0:
			motion.x = -max_speed
		else:
			motion.x = max_speed
		motion = move_and_slide(motion, UP)
	pass

func jump():
	motion.y = jump_speed
	jump = false
	can_jump = false
	$Enemy_Timers.jump_start()
	pass

func is_against_player():
	body_names = []
	for body in bodies:
		body_names.append(body.name)
	if(body_names.find("Player") >= 0):
		return false
	else:
		return true
	pass

func _on_Jump_timer_timeout():
	jump = false
	can_jump = true
	pass

func _on_Search_timer_timeout():
	player_last_pos = spawn_pos
	pass

func is_hit_by_bullet(bullet_side, bullet_dam):
	if is_hit == false:
		$Body/Sprite.set_modulate(Color(255, 0, 0, 1))
		$Enemy_Timers.is_hit_start()
		is_hit = true
		Globals.ScreenShaker.screen_shake( 0.6*self.scale.x, 10*(self.scale.x/2), 2)
		if current_poise <= 0:
			get_knocked_back(bullet_side)
		else:
			current_poise -= bullet_dam
		move()
		$Health.take_damage(bullet_dam)
		max_speed *= 1.05
		move_speed *= 1.1
		jump_speed *= 1.1
	pass

func get_knocked_back(bullet_side):
	motion.y = knockback.y
	if bullet_side == "left":
		motion.x = knockback.x
	if bullet_side == "right":
		motion.x = -knockback.x
	pass

func die():
	Globals.ScreenShaker.screen_shake( 1, 15*self.scale.x, 3)
	queue_free()
	pass

func _on_Hit_time_timeout():
	$Body/Sprite.set_modulate(Color(1, 1, 1, 1))
	pass

func _on_Inv_time_timeout():
	is_hit = false
	pass