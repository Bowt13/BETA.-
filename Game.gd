extends Node2D

export (bool) var is_test = false

var Globals = {
	'currentCamera': null,
	'ScreenShaker': null
	}

var Gravity = ProjectSettings.get_setting("physics/2d/Gravity")

func _ready():
	if is_test:
		get_tree().quit()
#	print("Game.gd gravity = ",Gravity)
	pass
