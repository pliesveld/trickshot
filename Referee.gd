extends Sprite2D


func _ready():
	self.add_to_group("entities")
	self.set_physics_process(true)
	self.set_process(true)
	pass

func start():
	pass
	
func reset():
	self.visible = true
	$"../Puck".global_transform.origin = self.global_transform.origin
	$RemoteTransform2D.remote_path = ^"../../Puck"
	
func drop_puck():
	$RemoteTransform2D.remote_path = NodePath("")
	self.visible = false
	$"../Puck".global_transform.origin = self.global_transform.origin
	$"../Puck".linear_velocity = Vector2(0.0, randi_range(-1,1)*randf_range(150.0, 350.0))
