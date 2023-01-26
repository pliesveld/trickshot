extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const center_line = 350
const goal_width = 50
const speed = 300
const MAX_SPEED = 1

func _ready():
	set_physics_process(false)
	self.add_to_group("entities")

func start():
	self.set_physics_process(true)

func reset():
	self.velocity = Vector2.ZERO
	set_physics_process(false)

func _physics_process(delta):
		var input_y = Input.get_action_strength("player1_down") - Input.get_action_strength("player1_up")
		velocity.y += input_y * speed * delta
		
		self.move_and_collide(velocity)
		
		velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
		position.y = clamp(position.y, center_line - goal_width, center_line + goal_width)
