extends KinematicBody2D

var Player
var Player_body
var Player_sprite
var Player_pos
var dash_spd
var vec_spd
var STOP = Vector2(0,0)
const UP = Vector2(0,-1)

func _ready():
	self.hide()
	pass

func init(xPlayer, Dashing):
	Player = xPlayer 
	Player_body = Player.get_node("Body")
	$Body.scale = Player_body.scale
	$Body.shape.extents = Player_body.shape.extents
	Player_sprite = Player_body.get_node("Sprite")
	$Body/Sprite.scale = Player_sprite.scale
	$Body/Sprite.texture = Player_sprite.texture
	$Body/Sprite.hframes = Player_sprite.hframes
	dash_spd = Dashing.dash_spd
	$Timer.wait_time = Dashing.get_node("Dash/Timer").wait_time * 1
	pass

func reset():
	$Body/Sprite.scale = Player_sprite.scale
	position = Vector2(0,0)
	pass

func stop():
	self.hide()
	$Timer.stop()
	pass

func aim(pos):
	reset()
	self.show()
	$Timer.start()
	get_motion(pos)
	pass

func get_motion(pos):
	var vec1 =  (pos - Player_pos).normalized()
	vec_spd = Vector2(vec1.x * dash_spd, vec1.y * dash_spd)
	pass

func _on_Timer_timeout():
	vec_spd = STOP
	reset()
	aim(get_global_mouse_position())
	pass

func _physics_process(delta):
	if delta != delta:
		print(delta)
	Player_pos = Player.get_node("PlayerPos").global_position
	$Body/Sprite.frame = Player_sprite.frame
	if vec_spd:
		move_and_slide(vec_spd,UP)
	pass
