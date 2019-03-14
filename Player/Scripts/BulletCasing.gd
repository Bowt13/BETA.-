extends RigidBody2D

var eject_vel
var rot
var min_vel = 5

func _ready():
	set_continuous_collision_detection_mode(true)
	pass

func eject(parent, dir):
	set_global_rotation_degrees(dir + 90)
	rot = dir + 90
#	eject_vel = Vector2( rand_range(-100,100), -550) * Vector2(sin(rot), cos(rot))
	eject_vel = Vector2( rand_range(-100,100), -450)
	set_linear_velocity(eject_vel) 
	parent.add_child(self)
	pass

func _physics_process(delta):
	if delta != delta:
		print(delta)
	var area_bodies = $Area2D.get_overlapping_bodies()
	for body in area_bodies:
		if "Wall" in body.name:
				$Sounds/Drop.play()
				$CollisionShape2D.set_disabled(false)
	var bodies = self.get_colliding_bodies()
	for body in bodies:
		set_sleep_timer(body)
		if "Wall" in body.name:
			if(self.bounce >= 0.1):
				self.bounce -= 0.1
			elif(self.bounce < 0.1):
				self.bounce = 0
			if(self.friction <= 0.9):
				self.friction += 0.1
			elif(self.friction > 0.9):
				self.friction = 1
	pass

func set_sleep_timer(body):
	if "Wall" in body.name or "Casing" in body.name:
		if $Sleep_timer.is_stopped():
			if self.linear_velocity.x < min_vel  and self.linear_velocity.x > -min_vel:
				if self.linear_velocity.y < min_vel  and self.linear_velocity.y > -min_vel:
					$Sleep_timer.start()
	else:
		if $Sleep_timer.is_stopped() == false:
			$Sleep_timer.stop()
	pass

func _on_Sleep_timer_timeout():
	if get_child_count() == 7:
		$GhostTrail.queue_free()
	set_mode(MODE_STATIC)
	pass


func _on_Disabled_timer_timeout():
	$CollisionShape2D.set_disabled(false)
	pass


func _on_Grow_timer_timeout():
	if $Sprite.get_scale().x < 1:
		$Sprite.set_scale($Sprite.get_scale() + Vector2(0.05, 0.05))
	pass
	
