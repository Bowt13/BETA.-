extends Container

var Health
var h_value
var max_health = 0 setget set_max_health
var health = 0 setget set_health
var new_health = 0
var old_health = 0

var Dash
var dash = 0 setget set_dash

var is_initialized = false

func _initialize(Player):
	if !is_initialized:
		is_initialized = true
		if Player.has_node('HealthHandler'):
			Health = Player.get_node('HealthHandler')
			h_value = Health.player_health
		else:
			h_value = Player.health
		if Player.has_node('StatesHandler/Move/Dashing'):
			Dash = Player.get_node('StatesHandler/Move/Dashing')

		set_max_health(h_value)
		set_health(h_value)
		connect_health_signals(Health)
		connect_dash_signals(Dash)
	pass

func set_max_health(new_value):
	max_health = new_value
	old_health = new_value
	for inner in $Life.get_children():
		if "1" in inner.name:
			inner.max_value = new_value/$Life.get_children().size()
		else:
			inner.max_value = new_value/$Life.get_children().size()
	pass
	
func set_health(new_value):
	$TweenLife.interpolate_method(self, "change_health", health, new_value, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0)
	$TweenLife.start()
	new_health = new_value
	$ReLifeDelay.start()
	pass

func change_health(new_value):
	health = round(new_value)
## EMPTY BAR SEGMENTS
	if new_value <= $Life/Inner1.max_value:
		$Life/Inner1.value = new_value
	if new_value <= $Life/Inner1.max_value + 20:
		$Life/Inner2.value = new_value - ($Life/Inner1.max_value)
	if new_value <= $Life/Inner1.max_value + 40:
		$Life/Inner3.value = new_value - ($Life/Inner1.max_value + 20)
	if new_value <= $Life/Inner1.max_value + 60:
		$Life/Inner4.value = new_value - ($Life/Inner1.max_value + 40)
	if new_value <= $Life/Inner1.max_value + 80:
		$Life/Inner5.value = new_value - ($Life/Inner1.max_value + 60)

## FILL BAR SEGMENTS
	if new_value > $Life/Inner1.max_value:
		$Life/Inner1.value = $Life/Inner1.max_value
	if new_value > $Life/Inner1.max_value + 20:
		$Life/Inner2.value = $Life/Inner2.max_value
	if new_value > $Life/Inner1.max_value + 40:
		$Life/Inner3.value = $Life/Inner3.max_value
	if new_value > $Life/Inner1.max_value + 60:
		$Life/Inner4.value = $Life/Inner3.max_value
	if new_value > $Life/Inner1.max_value + 80:
		$Life/Inner5.value = $Life/Inner3.max_value
	pass

func change_health_rechargable(new_value):
	health = round(new_value)
## EMPTY BAR SEGMENTS
	if new_value <= $Life/Inner1.max_value:
		$ReLife/Inner1.value = new_value
	if new_value <= $Life/Inner1.max_value + 20:
		$ReLife/Inner2.value = new_value - ($Life/Inner1.max_value)
	if new_value <= $Life/Inner1.max_value + 40:
		$ReLife/Inner3.value = new_value - ($Life/Inner1.max_value + 20)
	if new_value <= $Life/Inner1.max_value + 60:
		$ReLife/Inner4.value = new_value - ($Life/Inner1.max_value + 40)
	if new_value <= $Life/Inner1.max_value + 80:
		$ReLife/Inner5.value = new_value - ($Life/Inner1.max_value + 60)

## FILL BAR SEGMENTS
	if new_value > $Life/Inner1.max_value:
		$ReLife/Inner1.value = $Life/Inner1.max_value
	if new_value > $Life/Inner1.max_value + 20:
		$ReLife/Inner2.value = $Life/Inner2.max_value
	if new_value > $Life/Inner1.max_value + 40:
		$ReLife/Inner3.value = $Life/Inner3.max_value
	if new_value > $Life/Inner1.max_value + 60:
		$ReLife/Inner4.value = $Life/Inner3.max_value
	if new_value > $Life/Inner1.max_value + 80:
		$ReLife/Inner5.value = $Life/Inner3.max_value
	pass

func set_dash(new_value):
	dash = new_value
	if new_value <= 100:
		$Dash/Inner1.value = new_value
	if new_value <= 200:
		$Dash/Inner2.value = new_value - 100
	if new_value <=  300:
		$Dash/Inner3.value = new_value - 200
	if new_value > 100:
		$Dash/Inner1.value = $Dash/Inner3.max_value
	if new_value > 200:
		$Dash/Inner2.value = $Dash/Inner2.max_value
	if new_value > 300:
		$Dash/Inner3.value = $Dash/Inner1.max_value
	pass

func connect_health_signals(emitter):
	emitter.connect("health_changed", self, "_on_Player_health_changed")
	emitter.connect("health_depleted", self, "_on_Player_health_depleted")
	pass

func _on_Player_health_changed(new_health):
	set_health(new_health)
	pass

func _on_Player_health_depleted():
	
	pass
	
func connect_dash_signals(emitter):
	emitter.connect("dash_changed", self, "_on_Player_dash_changed")
	pass
	
func _on_Player_dash_changed(new_dash):
	set_dash(new_dash)
	pass


func _on_ReLifeDelay_timeout():
	$TweenReLife.interpolate_method(self, "change_health_rechargable", old_health, new_health, 1, Tween.TRANS_QUAD, Tween.EASE_OUT, 0)
	$TweenReLife.start()
	if health < old_health:
		old_health = health
	pass
