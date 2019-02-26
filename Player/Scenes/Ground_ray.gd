extends RayCast2D

onready var Player = $'../../../'
signal on_ground

func _ready():
	ignore_children(Player)
	pass

func ignore_children(node):
	if has_children(node):
		for child in node.get_children():
			if has_children(child):
				ignore_children(child)
	add_exception(node)
	pass

func has_children(node):
	if node.get_children().size() > 0:
		return(true)
	else:
		return(false)
	pass

func _physics_process(delta):
	check_collision()
	pass

func check_collision():
	if is_colliding():
		var Collider = get_collider()
		if Collider:
			if Collider.is_in_group("World") or Collider.is_in_group("Enemy"):
				emit_signal('on_ground', self.name, true)
			else:
				add_exception(Collider)
				emit_signal('on_ground', self.name, false)
	else:
		emit_signal('on_ground', self.name, false)
	pass
