extends Node2D

export(PackedScene) var ghost_scene
export (float, 0.01, 1) var set_opacity = 0.1
export (float, 0.01, 1) var set_time = 0.2
var this_ghost
var ghost_sprite
var ghost_direction
var ghost_scale

var Parent
var Sprite

func _ready():
	Parent = get_parent()
	if Parent.has_node("Body"):
		Sprite = $"../Body/Sprite"
	elif  Parent.has_node("Sprite"):
		Sprite = $"../Sprite"
	elif  Parent.has_node("Ghost"):
		Sprite = $"../Ghost"
	get_ghost()
	$Ghost_Timer.start()
	pass

func return_opacity():
	if Parent.has_node('States'):
		var States = Parent.get_node('States')
		if States.has_method('move'):
			if States.move("dashing"):
				return(1);
			else:
				return(set_opacity);
		else:
			return(set_opacity);
	else:
		return(set_opacity);
	pass

func get_ghost():
	this_ghost = ghost_scene.instance()
	if Sprite:
		ghost_sprite = Sprite.texture
		ghost_direction = Sprite.rotation + Parent.rotation
		ghost_scale = Vector2(Sprite.scale.x * Parent.scale.x, Sprite.scale.y * Parent.scale.y)
	pass

func set_ghost():
	if this_ghost:
		this_ghost.texture	= ghost_sprite
		this_ghost.position	= Sprite.global_position
		this_ghost.rotation	= ghost_direction
		this_ghost.scale	= ghost_scale
		this_ghost.hframes	= Sprite.hframes
		this_ghost.frame	= Sprite.frame
		this_ghost.set_tween(return_opacity(), set_time)
	pass

func stop_ghost():
	$Ghost_Timer.stop()
	pass

func _on_Ghost_Timer_timeout():
	if "..":
		get_ghost()
		set_ghost()
		$"../../".add_child(this_ghost)
		this_ghost.start()
	pass