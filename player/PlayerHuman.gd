extends PlayerBase

func _ready():
	super()
	self.add_to_group("players")

func _physics_process(delta):
	input_y = Input.get_action_strength("%s_down" % self.name) - Input.get_action_strength("%s_up" % self.name)
	input_x = Input.get_action_strength("%s_right" % self.name) - Input.get_action_strength("%s_left" % self.name)

	super(delta)
	
	if Input.get_action_strength("%s_shoot" % self.name, true) and $RemoteTransform2D.remote_path != NodePath(""):
		player_shoot()
	
