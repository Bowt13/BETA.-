extends Area2D

onready var Camera = $"../Camera2D"

func _ready():
	var zoom = Camera.zoom
	$Field.shape.extents *= zoom
	$"Field/Barriers".scale *= zoom
	pass

func update_camera(zoom):
	$Field.shape.extents *= zoom
	$"Field/Barriers".scale *= zoom
	pass