extends Node2D

onready var aiming_state = $'../Aiming'.state
onready var Movement = $'../../MovementHandler'

var state = false
var current_dir = 0
var current_state

func _ready():
	pass

func _physics_process(delta):
	if delta:
		if $Dashing.state:
			if $Walking.state:
				$Walking.exit()
		else:
			if state == true:
				get_aiming_state()
				if aiming_state:
					if current_state == 'Walking': return
					current_state = 'Walking'
					$Walking.enter()
				else:
					if $Walking.state:
						$Walking.exit()

	pass

func enter(dir):
	state = true
	current_dir = dir
	Movement.set_direction(dir)
	print(self.name, ' entered')
	pass

func exit():
	state = false
	current_state = null
	current_dir = 0
	Movement.set_direction(0)
	for child in get_children():
		if child.state:
			child.exit()
	print(self.name, ' exited')
	pass

func change_dir(new_dir):
	current_dir = new_dir
	Movement.set_direction(new_dir)
	pass

func get_aiming_state():
	aiming_state = $'../Aiming'.state
	pass
