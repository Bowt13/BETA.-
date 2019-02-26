extends Node2D

signal took_damage(amount)
signal took_hit(amount)
signal health_changed(new_health)
signal health_added(new_health, new_max_health)
signal health_depleted

var max_health = 50
var health = 50

func initialize(enemy_health):
	max_health = enemy_health
	health = max_health
	pass

func _physics_process(delta):
	pass

func take_damage(bullet_dam):
	health -= bullet_dam
	check_health()
	pass

func add_health(extra_health, extra_max_health):
	health += extra_health
	max_health += extra_max_health
	emit_signal("health_added", health, max_health)
	pass

func check_health():
	if health > 0:
		emit_signal("health_changed", health)
	else:
		self.get_parent().die()
		emit_signal("health_depleted")
	pass