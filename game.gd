extends Node2D

signal on_start

func _ready():
	$Timer.timeout.connect(func(): $%clock.text = str(int($%clock.text) - 1))
	reset()
	
func reset():
	self.get_tree().call_group("entities", "reset")
	$puck.linear_velocity = Vector2.ZERO
	$puck.linear_velocity = Vector2.ZERO
	$puck.global_transform.origin = Vector2(400, 400)
	#$puck.transform.origin = Vector2.ZERO
	$Player.global_transform.origin = Vector2(200, 400)
	$golie.global_transform.origin = Vector2(70, 400)
	$Referee.global_transform.origin = Vector2(420, 152)
	$Timer.stop()
	start()

func start():

	var tween = self.get_tree().create_tween()
	tween.tween_callback(func(): $Referee.reset())
	tween.tween_property($Referee, "global_transform:origin:y", 352.0, 3.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).from(152.0)
	tween.tween_callback(func(): $Referee.drop_puck()).set_delay(4.0)
	tween.tween_callback(func(): 
		self.get_tree().call_group("entities", "start")
		$Timer.start()
		$AudioStart.play())
	

	
	


func _unhandled_input(event):
	if event is InputEventKey and event.pressed == true:
		if event.keycode == KEY_Q:
			reset()
