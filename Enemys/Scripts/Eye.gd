extends Node2D

var Ray
var Collider
onready var Enemy = $"../.."

func _ready():
	Ray = $RayCast2D
	Ray.set_enabled(true)
	Ray.force_raycast_update()
	Collider = Ray.get_collider()
	$Timer.start()
	pass
	
func _physics_process(delta):
	Collider = Ray.get_collider()
	if Collider:
		if "Player" in Collider.name:
			Enemy.player_spotted(Collider.global_position)
		else:
			Ray.add_exception(Collider)
	pass

func _on_Timer_timeout():
	queue_free()
	pass
