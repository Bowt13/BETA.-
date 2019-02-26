extends RemoteTransform2D

func _ready():
	pass

func _on_Enemy_change_scale(new_scale):
	var scale = Vector2(1/new_scale.x ,1/new_scale.y)
	self.scale = scale
	pass