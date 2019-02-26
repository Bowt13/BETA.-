extends RigidBody2D

export(PackedScene) var Gun_Scene

func _ready():
	pass

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body.has_node('GunHandler'):
			if false in body.get_node('GunHandler').has_guns():
				body.get_node('GunHandler').get_gun(Gun_Scene)
				queue_free()
				return
		if body.is_in_group("Enemy") or body.is_in_group("Player"):
			self.add_collision_exception_with(body)
	pass