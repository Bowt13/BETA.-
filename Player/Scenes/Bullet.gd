extends Area2D

onready var Globals = $'/root/Game'.Globals

var bullet_speed
var bullet_dir
var bullet_dam
var bullet_side
var bullet_init_pos
var bullet_normal
var going_left
var bullet_hit_pos
var bullet_hit_point

var legit_bodies =	["Enemy", "Wall"] 
var legit_normals =	["left", "right", "top", "bottom", "Enemy"]

var Shooter

# PARENT
var Parent
var GParent

#CHILDREN
var Ray

#ROCKS
export(PackedScene) var Rocks_scn
var Rocks
var rocks_dir
var self_dir

func _ready():
	Parent = $".."
	GParent = $"../.."
	Ray = $RayCast2D
	pass

func set_shooter(GunOwner):
	Shooter = GunOwner
	pass

func shoot(start_pos, target_pos, this_speed, damage, side):
	bullet_init_pos = start_pos
	going_left = side
	set_damage(damage)
	set_pos_speed(start_pos, target_pos, this_speed/2)
	pass

func set_damage(damage):
	bullet_dam = damage
	pass

func set_pos_speed(pos, target, this_speed):
	self.set_global_position(pos)
	bullet_speed = this_speed * ((target - pos).normalized())
	look_at(target)
	pass

func _physics_process(delta):
	check_hits()
	bullet_normal_check()
	fly()
	pass

func fly():
	self.global_position += bullet_speed
	pass

func check_hits():
	var bodies = get_overlapping_bodies()
	if !bodies:
		$Body/Sprite.scale = Vector2(1,1)
	for body in bodies:
		if(body.name == "Player"):
			pass
		else:
			if "Wall" in body.name or "Enemy" in body.name:
				queue_free()
			if body.is_in_group("Enemy"):
				check_hit_side(body)
				if body.has_method("is_hit_by_bullet"):
					body.is_hit_by_bullet(bullet_side, bullet_dam)
				if Shooter:
					if Shooter.has_method("enemy_hit"):
						Shooter.enemy_hit()
				pass
			if body.name == "Forcefield":
				$Body/Sprite.scale = Vector2(0,0)
			else:
				if bullet_hit_pos:
					Rocks = Rocks_scn.instance()
					Rocks.set_global_position(Vector2( bullet_hit_pos.x + 16, bullet_hit_pos.y - 16))
					self_dir = self.get_rotation_degrees()
					if self_dir < 0:
						self_dir = -self_dir
					if bullet_normal == "left":
						rocks_dir = (90 - self_dir) + 90
						rocks_dir = 180 - rocks_dir
						rocks_dir = 180 - rocks_dir
						if bullet_hit_point == "up":
							rocks_dir = -rocks_dir
							
					elif bullet_normal == "right":
						rocks_dir = 180 - ((self_dir - 90) + 90)
						if bullet_hit_point == "up":
							rocks_dir = -rocks_dir
							
					elif bullet_normal == "top":
						rocks_dir = 180 - ((self_dir - 90) + 90)
						if going_left:
							rocks_dir = -(180 - ((90 - self_dir) + 90))
						else:
							rocks_dir = -(180 - (180 - ((self_dir - 90) + 90)))
					elif bullet_normal == "bottom":
						if going_left:
							rocks_dir = 180 - (180 - ((self_dir - 90) + 90))
						else:
							rocks_dir = (180 - ((90 - self_dir) + 90))
					Rocks.set_rotation_degrees(rocks_dir)
					Rocks.explode()
					self.get_parent().add_child(Rocks)
	pass

func bullet_normal_check():
	if bullet_normal in legit_normals:
		return
	else:
		bullet_normal = get_bullet_normal()
	pass

func get_bullet_normal():
	if Ray.is_colliding():
		var Collider = Ray.get_collider()
		if Collider:
			if Collider.get_parent().has_method("is_hit_by_bullet"):
				bullet_normal = "Enemy"
			elif "Wall" in Collider.name:
				bullet_hit_pos = Ray.get_collision_point()
				bullet_hit_point = bullet_hit_pos
				bullet_normal = Ray.get_collision_normal()
				if bullet_normal == Vector2(0,0):
					return
				if bullet_init_pos.y > bullet_hit_point.y:
					bullet_hit_point = 'up'
				elif bullet_init_pos.y < bullet_hit_point.y:
					bullet_hit_point = 'down'
				else:
					bullet_hit_point = "level"
				if bullet_normal.x < 0:
					bullet_normal = "left"
				elif bullet_normal.x > 0:
					bullet_normal = "right"
				elif bullet_normal.y < 0:
					bullet_normal = "top"
				elif bullet_normal.y > 0:
					bullet_normal = "bottom"
			else:
				Ray.add_exception(Collider)
	return(bullet_normal)
	pass

func check_hit_side(body):
	var body_pos = body.position.x
	if (bullet_init_pos.x - body_pos < 0):
		bullet_side = "left"
	elif (bullet_init_pos.x - body_pos > 0):
		bullet_side = "right"
	pass

func _on_Bullet_body_entered(body):
	if body.is_in_group("World") or body.is_in_group("Player"):
		if body != Shooter:
			queue_free()
			if body.is_in_group("Destructable"):
				body.destroy($Position2D)
	if(body.name != "Player"):
		if bullet_normal == body.name:
			check_hit_side(body)
			body.is_hit_by_bullet(bullet_side, bullet_dam)
			pass
		else:
			if bullet_hit_pos:
				Rocks = Rocks_scn.instance()
				Rocks.set_global_position(Vector2( bullet_hit_pos.x + 16, bullet_hit_pos.y - 16))
				self_dir = self.get_rotation_degrees()
				rocks_dir = get_rocks_dir()
				Rocks.set_rotation_degrees(rocks_dir)
				self.get_parent().add_child(Rocks)
				Rocks.explode()
				queue_free()
	pass

func get_rocks_dir():
	if self_dir < 0:
		self_dir = -self_dir
	if bullet_normal == "left" or bullet_normal == "right":
		return -(180 - self_dir)
	elif bullet_normal == "top":
		return -self_dir
	elif bullet_normal == "bottom":
		return self_dir
	pass