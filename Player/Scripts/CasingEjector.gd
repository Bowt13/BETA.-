extends Node2D

const bullet_casing_scene = preload("res://Player/Scenes/BulletCasing.tscn")
var this_bullet_casing

func eject_casing(parent, pos):
	if $"..".flip_h:
		$Position2D.position = Vector2( -6, -10)
	else:
		$Position2D.position = Vector2( 10, 5)
	this_bullet_casing = bullet_casing_scene.instance()
	this_bullet_casing.global_position = $Position2D.global_position
	this_bullet_casing.eject(parent, get_global_rotation_degrees())