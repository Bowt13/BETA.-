extends Node2D

onready var Globals = $'/root/Game'.Globals

var current_shake_priority = 0

func _ready():
	Globals.ScreenShaker = self
	pass

func move_camera(vector):
	Globals.currentCamera.offset = Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y))
	pass 

func screen_shake(shake_length, shake_amplitude, shake_priority):
	if shake_priority >= current_shake_priority:
		current_shake_priority = shake_priority
		shake_amplitude = Vector2(shake_amplitude, shake_amplitude)
		$Tween.interpolate_method(self, "move_camera", shake_amplitude, Vector2( 0, 0), shake_length, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
		$Tween.start()
	pass



func _on_Tween_completed(object, key):
	print(object, key)
	current_shake_priority = 0
	pass
