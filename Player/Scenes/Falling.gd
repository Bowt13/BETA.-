extends Node2D

var state = false
onready var Movement = $"../../MovementHandler"

onready var Gravity
var default_Gravity

func _ready():
	exit()
	pass

func _on_Player_share_Physics(new_Physics):
	Gravity = new_Physics.Gravity
	pass

func _physics_process(delta):
	if false in Movement.airborn:
		if state:
			exit()
	else:
		if !state:
			enter()
	pass

func enter():
	state = true
	if Gravity > 0:
		default_Gravity = Gravity
	if Gravity == 0:
		Gravity = default_Gravity
	Movement.set_gravity(Gravity)
	print(self.name, ' entered')
	pass

func exit():
	state = false
	Movement.set_gravity(0)
	print(self.name, ' exited')
	pass
