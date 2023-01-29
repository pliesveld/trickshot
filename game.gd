extends Node2D

signal on_start

func _ready():
	$%Timer.timeout.connect(func(): 
		var clock_value:int = int($%clock.text)
		if clock_value <= 0:
			end()
		else:
			$%clock.text = str(clock_value - 1))
	reset()
	
func reset():
	self.get_tree().call_group("entities", "reset")
	$Puck.linear_velocity = Vector2.ZERO
	$Puck.global_transform.origin = Vector2(400, 400)
	$Player.global_transform.origin = Vector2(200, 400)
	$%PlayerComputer.global_transform.origin = Vector2(600, 400)
	$Goalie.global_transform.origin = Vector2(70, 400)
	$GoalieComputer.global_transform.origin = Vector2(784, 400)
	$Referee.global_transform.origin = Vector2(420, 152)
	$Timer.stop()
	($%AudioEnd as AudioStreamPlayer).stop()
	start()

func start():
	var tween = self.get_tree().create_tween()
	tween.tween_callback(func(): $Referee.reset())
	tween.tween_property($Referee, "global_transform:origin:y", 352.0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).from(152.0)
	tween.tween_callback(func(): $Referee.drop_puck()).set_delay(1.5)
	tween.tween_callback(func(): 
		self.get_tree().call_group("entities", "start")
		$Timer.start()
		$AudioStart.play())

func end():
	$%Timer.stop()
	$Player.set_physics_process(false)
	$%PlayerComputer.set_physics_process(false)
	$%Puck.set_physics_process(false)
	($%AudioEnd as AudioStreamPlayer).play()


func _unhandled_input(event):
	if event is InputEventKey and event.pressed == true:
		if event.keycode == KEY_Q:
			reset()
