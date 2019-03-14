extends Node2D

var all_state_nodes =		[]
var all_state_values =		[]

var idle_state_nodes =		[]
var idle_state_values=		[]

var move_state_nodes =		[]
var move_state_values =		[]

var jumping_state_nodes =	[]
var jumping_state_values=	[]

var sliding_state_nodes =	[]
var sliding_state_values =	[]

var status_state_nodes =	[]
var status_state_values =	[]

var aiming_state_nodes =	[]
var aiming_state_values =	[]


var current_move_state
var current_move_sub_state

var current_jump_state

var current_aim_state

func _ready():
	get_all_state_nodes()
	pass

func get_all_state_nodes():
	for child in get_children():
		all_state_nodes.push_back (child)
		get_grandchildren(child, all_state_nodes)
		match child.name:
			'Idle':
				idle_state_nodes.push_back(child)
				get_grandchildren(child, idle_state_nodes)
			'Move':
				move_state_nodes.push_back(child)
				get_grandchildren(child, move_state_nodes)
			'Jumping':
				jumping_state_nodes.push_back(child)
				get_grandchildren(child, jumping_state_nodes)
			'Sliding':
				sliding_state_nodes.push_back(child)
				get_grandchildren(child, sliding_state_nodes)
			'Status':
				status_state_nodes.push_back(child)
				get_grandchildren(child, status_state_nodes)
			'Aiming':
				aiming_state_nodes.push_back(child)
				get_grandchildren(child, aiming_state_nodes)
	pass

func _physics_process(delta):
	if delta:
		check_if_idle()
	pass

func check_if_idle():
	if move_state_values.has(true) or jumping_state_values.has(true) or sliding_state_values.has(true):
		if $Idle.state:
			$Idle.exit()
			print('Idle exited')
	else:
		if !$Idle.state:
			$Idle.enter()
			print('Idle entered')
	pass

func get_all_state_values():
	clear_values()
	#ALL
	for node in all_state_nodes:
		all_state_values.push_back(node.state)
	#IDLE
	for node in idle_state_nodes:
		idle_state_values.push_back(node.state)
	#MOVE
	for node in move_state_nodes:
		move_state_values.push_back(node.state)
	#JUMPING
	for node in jumping_state_nodes:
		jumping_state_values.push_back(node.state)
	#SLIDING
	for node in sliding_state_nodes:
		sliding_state_values.push_back(node.state)
	#STATUS
	for node in status_state_nodes:
		status_state_values.push_back(node.state)
	#AIMING
	for node in aiming_state_nodes:
		aiming_state_values.push_back(node.state)
	pass

func clear_values():
	all_state_values.clear()
	idle_state_values.clear()
	move_state_values.clear()
	jumping_state_values.clear()
	sliding_state_values.clear()
	status_state_values.clear()
	aiming_state_values.clear()
	pass

func get_grandchildren(child, array):
	if child.name == 'Move':
		return
	if child.get_children().size() > 0:
		for grandchild in child.get_children():
			array.push_back (grandchild)
		pass

func _on_new_move_state(new_state, sub_state):
	if sub_state and sub_state == 10:
		$Move/Dashing.exit_charging()
		$Move/Dashing.enter()
	elif sub_state and sub_state == 9:
		$Move/Dashing.enter_charging()
	elif !$Status/Stunned.state or !$Move/Dashing:
		if current_move_state == new_state and sub_state == current_move_sub_state:
			return
		current_move_sub_state = sub_state
		current_move_state = new_state
		for node in move_state_nodes:
			if node.name == new_state:
				if !node.state:
					if sub_state or sub_state == 0:
						node.enter(sub_state)
					else:
						node.enter()
				else:
					node.change_dir(sub_state)
			elif node.state:
				node.exit()
		get_all_state_values()
	pass

func _on_new_jump_state(new_state, sub_state):
	if current_jump_state == new_state: return
	current_jump_state = new_state
	for node in jumping_state_nodes:
		if node.name == new_state:
			if !node.state:
				if sub_state:
					node.enter(sub_state)
				else:
					node.enter()
		elif node.state:
			node.exit()
	get_all_state_values()
	pass

func _on_new_aim_state(new_state):
	if $"../GunHandler".has_guns():
		current_aim_state = new_state
		for node in aiming_state_nodes:
			if node.name == new_state:
				if !node.state:
					node.enter()
		get_all_state_values()
	pass

func idle():
	return $Idle.state
	pass

func move(state):
	match state:
		"move":
			return $Move.state
		"walking":
			return $Move/Walking.state
		"running":
			return $Move/Running.state
		"dashing":
			return $Move/Dashing.state
		"recharge":
			return $Move/Dashing/Recharge.state
	pass

func jumping():
	return $Jumping.state
	pass

func airborn():
	return $Airborn.state
	pass

func sliding():
	return $Sliding.state
	pass

func status(state):
	match state:
		"Status":
			return $Status.state
		"stunned":
			return $Status/Stunned.state
		"invincible":
			return $Status/Invincible.state
	pass

func aiming():
	return $Aiming.state
	pass

func set_look_dir():

	pass