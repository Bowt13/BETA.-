extends Node2D

var max_health	= 0	setget set_max_health 
var health 		= 0	setget set_health

var health_node

func set_max_health(value):
	max_health = value
	$TextureProgress.max_value = value
	pass
	
func set_health(value):
	health = value
	$TextureProgress.value = value
	pass

func initialize(enemy):
	if (enemy.has_node("Health")):
		health_node = enemy.get_node("Health")
		health_node.connect("health_changed", self, "_on_Enemy_health_changed")
		health_node.connect("health_added", self, "_on_Enemy_health_added")
		health_node.connect("health_depleted", self, "_on_Enemy_health_depleted")
		
		if health_node.max_health:
			self.set_max_health(health_node.max_health)
			self.set_health(health_node.health)
		else:
			self.set_max_health(enemy.enemy_health)
			self.set_health(enemy.enemy_health)
	pass

func _on_Enemy_health_changed(new_health):
	$TextureProgress.value = new_health 
	self.health = new_health
	pass

func _on_Enemy_health_added(new_health, new_max_health):
	$TextureProgress.max_value = new_max_health
	$TextureProgress.value = new_health 
	self.health = new_health
	pass

func _on_Enemy_health_depleted():
	self.queue_free()
	pass
