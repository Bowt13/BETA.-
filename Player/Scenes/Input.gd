extends Node2D

#SIGNALS
	#GUN
signal aim_state
signal change_gun
signal charge_gun
signal pull_trigger
signal release_trigger

	#MOVEMENT
signal move_state
signal jump_state
signal slide_state

#CONTROLS
	#MOVE
var right
var left
var dash
var dash_chrg
var current_move
	#JUMPING
var jump_on
var jump_off 
	#SLIDING
var slide_on
var slide_off
	#GUN
var aim = true 
var charge_gun
var pull_trigger
var release_trigger
var change_gun

var menu

func _ready():
	pass

func _physics_process(delta):
	get_input()
	process_gun_input()
	process_movement_input()
	process_jump_input()
	process_slide_input()
	process_menu_input()
	pass

func get_input():
	#MOVE
	right 			= Input.is_action_pressed("ui_right")
	left 			= Input.is_action_pressed("ui_left")
	dash_chrg		= Input.is_action_just_pressed("ui_charge_gun")
	dash			= Input.is_action_just_released("ui_charge_gun")

	#JUMPING
	jump_on 		= Input.is_action_pressed("ui_jump")
	jump_off 		= Input.is_action_just_released("ui_jump")
	
	#SLIDING
	slide_on		= Input.is_action_pressed("ui_down")
	slide_off		= Input.is_action_just_released("ui_down")

	#GUN
	change_gun		= Input.is_action_just_pressed("ui_change_gun")
	pull_trigger	= Input.is_action_pressed("ui_shoot")
	release_trigger	= Input.is_action_just_released("ui_shoot")
	
	#MENU
	menu			= Input.is_action_pressed("ui_menu")
	pass

func process_gun_input():
	if aim:
		emit_signal('aim_state', 'Aiming')
	if charge_gun:
		emit_signal('charge_gun')
	if change_gun:
		emit_signal('change_gun')
	if pull_trigger:
		emit_signal('pull_trigger')
	if release_trigger:
		emit_signal('release_trigger')
	pass

func process_movement_input():
	if dash:
		emit_signal('move_state', 'Move', 10)
	elif dash_chrg:
		emit_signal('move_state', 'Move', 9)
	elif right or left:
		if right and left:
			if current_move == 'right':
				emit_signal('move_state', 'Move', -1)
			elif current_move == 'left':
				emit_signal('move_state', 'Move', 1)
			else:
				emit_signal('move_state', 'Move', 0)
		elif right:
			emit_signal('move_state', 'Move', 1)
			current_move = 'right'
		elif left:
			emit_signal('move_state', 'Move', -1)
			current_move = 'left'
		return
	else:
		emit_signal('move_state', 'none', null)
		current_move = 'none'
	pass

func process_jump_input():
	if jump_on:
		emit_signal('jump_state', 'Jumping', 'on')
		return
	if jump_off:
		emit_signal('jump_state', 'Jumping', 'off')
		return
	emit_signal('jump_state', 'none', null)
	pass

func process_slide_input():
	if slide_on:
		emit_signal('slide_state', 'Sliding', 'on')
		return
	if slide_off:
		emit_signal('slide_state', 'Sliding', 'off')
		return
	emit_signal('slide_state', 'none', null)
	pass

func process_menu_input():
	if menu:
		get_tree().quit()
	pass