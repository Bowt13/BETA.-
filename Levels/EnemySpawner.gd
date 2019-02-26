extends Area2D

export(PackedScene) var Enemy_Scene

onready var World = $"/root/Game/World"

var Enemy
var can_spawn = true
onready var Emitter = $Vacuum
signal spawned_enemy

func _ready():
	$Builder.value = 0
	Enemy = Enemy_Scene.instance()
	set_waittime(Enemy.spawn_time)
	pass

func _physics_process(delta):
	for area in get_overlapping_areas():
		if area.name == "CameraViewField":
			spawn_enemy()
	for body in get_overlapping_bodies():
		if body.name == "Player":
			var Stunned = body.get_node("States/Status/Stunned")
			if body.has_method("hit_by_enemy"):
				body.hit_by_enemy(false, 0, $Forcefield/Field/FieldCollision)
			if !Stunned.state:
				pass
				Stunned.enter()
			if $Forcefield:
				$Forcefield.emit()
	pass

func spawn_enemy():
	if can_spawn:
		can_spawn = false
		Emitter.emit()
		$Particle_timer.start()
		$Spawn_timer.start()
	pass 

func _on_Particle_timer_timeout():
	Emitter.stpemit()
	pass

func _on_Spawn_timer_timeout():
	$Forcefield.emit()
	if Enemy_Scene:
		Enemy.global_position = $Position2D.global_position
		World.call_deferred("add_child", Enemy)
		emit_signal('spawned_enemy', Enemy)
		self.queue_free()
	pass
	
func set_waittime(spawn_time):
	var life_time = Emitter.lifetime / Emitter.speed_scale
	$Spawn_timer.set_wait_time(spawn_time + life_time)
	$Particle_timer.set_wait_time(spawn_time + 0.3)
	pass

func reset():
	$Builder.value = 0
	can_spawn = true
	Enemy = Enemy_Scene.instance()
	set_waittime(Enemy.spawn_time)
	pass