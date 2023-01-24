extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
func reset():
	$puck.global_transform.origin = Vector2(400, 400)
	#$puck.transform.origin = Vector2.ZERO
	$player.global_transform.origin = Vector2(200, 400)
	$golie.global_transform.origin = Vector2(70, 400)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event is InputEventKey and event.pressed == true:
		if event.keycode == KEY_Q:
			reset()
