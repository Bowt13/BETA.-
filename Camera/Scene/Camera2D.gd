extends Camera2D

onready var Globals = $"/root/Game".Globals

func _ready():
	pass

func _physics_process(delta):
	if is_current() and Globals.currentCamera != self:
		Globals.currentCamera = self
	pass

func _on_Shake_timer_timeout():

	pass

func check():
	
	pass