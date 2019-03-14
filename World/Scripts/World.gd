extends Node2D

signal share_Physics()

var UP = Vector2(0, -1)
export (int, 1, 1000) var GRAVITY
export (int, 1, 5000) var MAX_GRAVITY
export (float, 0, 1) var GLIDE_RATIO

var Physics

func _init():

	pass

func _ready():
	Physics = {
		Up				= UP,
		Gravity			= GRAVITY,
		Max_Gravity		= MAX_GRAVITY,
		Glide_Ratio		= GLIDE_RATIO
	}
	emit_signal("share_Physics", Physics)
	pass

func set_up(new_Up):
	if Physics.Up != new_Up:
		Physics.Up = new_Up
		UP = new_Up
		emit_signal("share_Physics", Physics)
	pass

func set_gravity(new_Gravity):
	if Physics.Gravity != new_Gravity:
		Physics.Gravity = new_Gravity
		GRAVITY = new_Gravity
		emit_signal("share_Physics", Physics)
	pass

func set_Max_Fall_Vel(new_max_gravity):
	if Physics.Max_Gravity != new_max_gravity:
		Physics.Max_Gravity = new_max_gravity
		MAX_GRAVITY = new_max_gravity
		emit_signal("share_Physics", Physics)
	pass

func set_Glide_Ratio(new_Ratio):
	if Physics.Glide_Ratio != new_Ratio:
		Physics.Glide_Ratio = new_Ratio
		GLIDE_RATIO = new_Ratio
		emit_signal("share_Physics", Physics)
	pass

func _on_World_share_Physics(physics):
	print(physics)
	pass
