extends Area2D

export(PackedScene) var Item_Scene
export(bool) var Kill_item
export(float, 0 , 50) var Kill_after

onready var World = $"/root/Game/World"

var Item
var can_spawn = true
signal spawned_item

func _ready():
	if Kill_item:
		$Kill_timer.wait_time = Kill_after
	pass

func _physics_process(delta):
	for area in get_overlapping_areas():
		if area.name == "CameraViewField":
			spawn_item()
	pass

func spawn_item():
	if can_spawn:
		can_spawn = false
		if Item_Scene:
			Item = Item_Scene.instance()
			Item.global_position = $Position2D.global_position
			World.call_deferred("add_child", Item )
			if Kill_item:
				$Kill_timer.start()
			emit_signal('spawned_item', Item)
	pass 


func _on_Kill_timer_timeout():
	Item.queue_free()
	pass
