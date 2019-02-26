extends Node2D

onready var Player = $"../../../../"
onready var Player_Sprite = Player.get_node("Body/Sprite")
onready var Dashing = $"../"

func _ready():
	pass

func init():
	$Beam/AimBeam.init(Player, Dashing)
	pass

func cast_beam():
	$Beam/AimBeam.aim($Rotator/Aim_pos.global_position)
	pass

func stop():
	$Beam/AimBeam.stop()
	pass

func _physics_process(delta):
	$Rotator.look_at(Dashing.mouse_pos)
	pass