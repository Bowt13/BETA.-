extends Node2D

signal health_changed
signal health_added
signal health_depleted

var player_health = 100
var current_health = player_health

func _ready():
	pass

func take_damage(damage):
	current_health -= damage
	if current_health <= 0:
		emit_signal('health_depleted')
	else:
		emit_signal('health_changed', current_health)
	pass
	
func add_health(extra):
	current_health += extra
	emit_signal('health_added', current_health)
	pass