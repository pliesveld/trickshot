extends Node2D

func _ready():
	reset()
	
func reset():
	$puck.linear_velocity = Vector2.ZERO
	$puck.global_transform.origin = Vector2(400, 400)
	#$puck.transform.origin = Vector2.ZERO
	$player.global_transform.origin = Vector2(200, 400)
	$golie.global_transform.origin = Vector2(70, 400)


func _unhandled_input(event):
	if event is InputEventKey and event.pressed == true:
		if event.keycode == KEY_Q:
			reset()
