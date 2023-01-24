extends CharacterBody2D

var motion:Vector2

func _ready():
#	var tween:Tween = self.create_tween()
#	tween.tween_property(self, "position:x", 210, 1.0).from_current()
	
	var collisionShape2D:CollisionShape2D = $CharacterBody2D/CollisionShape2D
	set_physics_process(true)

const speed = 200
const MAX_SPEED = 120

func _physics_process(delta):
		var input_y = Input.get_action_strength("player1_down") - Input.get_action_strength("player1_up")
		var input_x = Input.get_action_strength("player1_right") - Input.get_action_strength("player1_left")
		
		velocity.y += input_y * speed * delta
		velocity.x += input_x * speed * delta

		self.move_and_slide()
		
		velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		
		if Input.get_action_strength("player1_shoot", true):
			$"../puck".linear_velocity = self.velocity * 4.0
			$RemoteTransform2D.remote_path = NodePath("")

