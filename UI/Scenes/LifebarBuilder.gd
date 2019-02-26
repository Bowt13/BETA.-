extends Node2D

export(PackedScene) var Lifebar

func _ready():
	for spawner in get_tree().get_nodes_in_group("Enemy_spawner"):
		spawner.connect("spawned_enemy", self, "_on_EnemySpawner_spawned_enemy")
	pass

func _on_EnemySpawner_spawned_enemy(enemy):
	create_lifebar(enemy)
	pass

func create_lifebar(enemy):
	if enemy.has_node("LifebarHook"):
		var lifebar = Lifebar.instance()
		var hook = enemy.get_node("LifebarHook")
		hook.add_child(lifebar)
		lifebar.initialize(enemy)
	pass