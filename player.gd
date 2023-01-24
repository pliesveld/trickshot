extends CharacterBody2D

var motion:Vector2

func _ready():
	set_physics_process(true)

const speed = 200
const MAX_SPEED = 120

func _physics_process(delta):
		var input_y = Input.get_action_strength("player1_down") - Input.get_action_strength("player1_up")
		var input_x = Input.get_action_strength("player1_right") - Input.get_action_strength("player1_left")
		
		if abs(input_y) > abs(input_x):
			if input_y > 0.0:
				rotation_degrees = 90
			else:
				rotation_degrees = 270
			pass
		elif abs(input_x) > abs(input_y):
			if input_x > 0.0:
				rotation_degrees = 0
			else:
				rotation_degrees = 180
		
		velocity.y += input_y * speed * delta
		velocity.x += input_x * speed * delta

		self.move_and_slide()
		
		velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		
		if Input.get_action_strength("player1_shoot", true) and $RemoteTransform2D.remote_path != NodePath(""):
			$"../puck".linear_velocity = self.velocity * 4.0
			$RemoteTransform2D.remote_path = NodePath("")


func _on_puck_body_entered(body):
	printt("Pick-up puck:", body)

func _on_area_2d_area_entered(area):
	$RemoteTransform2D.remote_path = ^"../../puck"
	printt("Pick-up puck:", area)
