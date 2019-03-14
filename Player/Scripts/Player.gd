 extends KinematicBody2D

#SIGNALS
signal share_Physics

#MOVEMENT
var motion = Vector2()

#SELF
var player_pos

#PHYSICS
var knockback = Vector2(1000, -1400)

#CONDITIONALS
var has_gun = false
var is_hit = false
var is_aiming = false
var is_pulling_trigger = false
var can_jump = true
var is_jumping = true

#FUNCTIONS
func _ready():
	$Body/AnimationPlayer.play("Player_idle")
	pass

func _on_World_share_Physics(new_Physics):
	emit_signal("share_Physics", new_Physics)
	pass

func _physics_process(delta):
	if delta != delta:
		print(delta)
#PLAYER
	#POSITION
	set_player_position()


func _on_Jump_timer_timeout():
	is_jumping = false
	pass

func _on_JumpCorrect_timer_timeout():
	can_jump = false
	pass

	#PLAYER
		#POSITION
func set_player_position():
	player_pos = self.get_global_position()
	pass

		#TAKE DAMAGE
func hit_by_enemy(player_side, damage, Dealer):
	if $StatesHandler.status("invincible"):
		self.add_collision_exception_with(Dealer)
	elif !player_side:
		print("check")
		return
	else:
		self.remove_collision_exception_with(Dealer)
		if is_hit == false:
			$Body/Sprite.set_modulate(Color(255, 0, 0, 1))
			$Player_Timers.is_hit_start()
			is_hit = true
			motion.y = knockback.y
			if player_side == "left":
				motion.x = knockback.x
			if player_side == "right":
				motion.x = -knockback.x
			$HealthHandler.take_damage(damage)
	pass

func _on_Hit_time_timeout():
	$Body/Sprite.set_modulate(Color(1, 1, 1, 1))
	pass

func _on_Inv_time_timeout():
	is_hit = false
	pass

func _on_Input_pull_trigger():
	if has_gun:
		if is_aiming:
			is_pulling_trigger = true
#			pull_trigger()
	pass

func enemy_hit():
	$StatesHandler/Move/Dashing.enemy_hit()
	pass