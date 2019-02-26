extends Node2D

var Globals = {
	'currentCamera': null,
	'ScreenShaker': null
	}

var Gravity = ProjectSettings.get_setting("physics/2d/Gravity")

func _ready():
	print("Game.gd gravity = ",Gravity)
	pass
