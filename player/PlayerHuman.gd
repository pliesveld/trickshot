extends PlayerBase


func _physics_process(delta):
	input_y = Input.get_action_strength("Player1_down") - Input.get_action_strength("Player1_up")
	input_x = Input.get_action_strength("Player1_right") - Input.get_action_strength("Player1_left")

	super(delta)
	
	if Input.get_action_strength("Player1_shoot", true) and $RemoteTransform2D.remote_path != NodePath(""):
		player_shoot()
	
