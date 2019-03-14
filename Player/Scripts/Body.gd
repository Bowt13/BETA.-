extends CollisionShape2D

onready var Player = $"../"

onready var sprite_scale = $Sprite.scale.x

export(float, 0.01, 1.0) var Turn_Time = 0.01

var look_dir = "RIGHT"

func _ready():
	pass

func _physics_process(delta):
	if delta != delta:
		print(delta)
	change_look_dir()
	pass

func change_look_dir():
	if Player.global_position.x > get_global_mouse_position().x:
		look_dir = "RIGHT"
		$TurnHandler.interpolate_method(self, "set_look_dir", $Sprite.scale.x, -sprite_scale, Turn_Time, 0, Tween.EASE_OUT_IN, 0)
	else:
		look_dir = "LEFT"
		$TurnHandler.interpolate_method(self, "set_look_dir", $Sprite.scale.x, sprite_scale, Turn_Time, 0, Tween.EASE_OUT_IN, 0)
	$TurnHandler.start()
	pass

func change_anim_speed(motionX):
	$AnimationPlayer.playback_active = true
	if look_dir == "RIGHT" and motionX > 0:
		$AnimationPlayer.playback_speed = -20
	if look_dir == "RIGHT" and motionX < 0:
		$AnimationPlayer.playback_speed = 20
	if look_dir == "LEFT" and motionX > 0:
		$AnimationPlayer.playback_speed = 20
	if look_dir == "LEFT" and motionX < 0:
		$AnimationPlayer.playback_speed = -20
	if motionX < 80 and motionX > -80:
		$AnimationPlayer.playback_active = false
		$Sprite.frame = 0
	pass

func set_look_dir(new_scale):
	$Sprite.scale.x = new_scale
	pass
