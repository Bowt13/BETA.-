extends TextureProgress

func _ready():
	hide()
	pass

func _physics_process(delta):
	if value == max_value:
		hide()
	else:
		show()
	var new_value = get_value()
	self.max_value = $"../Spawn_timer".get_wait_time()
	self.value = new_value
	pass
	
func get_value():
	return($"../Spawn_timer".get_wait_time() - $"../Spawn_timer".get_time_left())
	pass
	