class_name Player
extends CharacterBody2D


# Keep this in sync with the AnimationTree's state names and numbers.
enum States {
	IDLE = 0,
	SKATE = 1,
	SHOOT = 2,
}

enum Direction {
	EAST = 0,
	SOUTH_EAST = 1,
	SOUTH = 2,
	SOUTH_WEST = 3,
	WEST = 4,
	NORTH_WEST = 5,
	NORTH = 6,
	NORTH_EAST = 7,
}

var state : int = States.SKATE
var dir : int = Direction.EAST

const speed = 200
const MAX_SPEED = 285

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	self.add_to_group("entities")
	$AnimationTree.active = false

func start():
	$AnimationTree.active = false
	self.set_physics_process(true)
	$Area2D.set_deferred("monitoring", true)
	
func reset():
	$AnimationTree.active = false
	self.set_physics_process(false)
	self.velocity = Vector2.ZERO
	self.dir = Direction.EAST
	self.rotation_degrees = 0
	self.velocity = Vector2.ZERO
	$RemoteTransform2D.remote_path = NodePath("")
	

func _physics_process(delta):
	var input_y = Input.get_action_strength("Player1_down") - Input.get_action_strength("Player1_up")
	var input_x = Input.get_action_strength("Player1_right") - Input.get_action_strength("Player1_left")

	var new_rotation_degrees = 0 

	if abs(input_y) > abs(input_x):
		if input_y > 0.0:
			dir = Direction.SOUTH
			new_rotation_degrees = 90
		else:
			dir = Direction.NORTH
			new_rotation_degrees = 270
	elif abs(input_x) > abs(input_y):
		if input_x > 0.0:
			dir = Direction.EAST
			new_rotation_degrees = 0
		else:
			dir = Direction.WEST
			new_rotation_degrees = 180	
	elif input_x == input_y and input_x == 1:
		dir = Direction.SOUTH_EAST
		new_rotation_degrees = 45
	elif input_x == input_y and input_x == -1:
		dir = Direction.NORTH_WEST
		new_rotation_degrees = 225
	elif input_x == 1 and input_y == -1:
		dir = Direction.NORTH_EAST
		new_rotation_degrees = 315
	elif input_x == -1 and input_y == 1:
		dir = Direction.SOUTH_WEST
		new_rotation_degrees = 135

		
	self.rotation_degrees = new_rotation_degrees
	
	velocity.y += input_y * speed * delta
	velocity.x += input_x * speed * delta

	self.move_and_slide()
#
#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
#		if "collider" in collision:
#			printt("Collided with: ", collision.collider.name)
#
#
	var collision:KinematicCollision2D = self.get_last_slide_collision()
	if collision != null:
#		printt("collision", collision.get_normal())
#		printt("player velocity", self.velocity)
		self.velocity += (collision.get_normal()*collision.get_depth()*14000.0)
		
	
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	$AnimationTree.set("parameters/skate_animation_timescale/scale", maxf(6.5*absf(velocity.x)/MAX_SPEED,6.5*absf(velocity.y)/MAX_SPEED))
	
	
	if Input.get_action_strength("Player1_shoot", true) and $RemoteTransform2D.remote_path != NodePath(""):
		state = States.SHOOT
		$AnimationTree["parameters/shoot/active"] = true

#		var puck_velocity = (Vector2(input_y * speed * delta, input_x * speed * delta) * speed * 0.7) # (self.velocity * 4.0 * 0.3) + 
#		$"../Puck".linear_velocity = puck_velocity
#		$"../Puck".linear_velocity = Vector2.RIGHT * 8*MAX_SPEED
		
		var puck_velocity
		
		match self.dir:
			Direction.EAST:
				puck_velocity = Vector2(1, 0)
			Direction.SOUTH_EAST:
				puck_velocity = Vector2(1, 1)
			Direction.SOUTH:
				puck_velocity = Vector2(0, 1)
			Direction.SOUTH_WEST:
				puck_velocity = Vector2(-1, 1)
			Direction.WEST:
				puck_velocity = Vector2(-1, 0)
			Direction.NORTH_WEST:
				puck_velocity = Vector2(-1, -1)
			Direction.NORTH:
				puck_velocity = Vector2(0, -1)
			Direction.NORTH_EAST:
				puck_velocity = Vector2(1, -1)
		
		
		puck_velocity *= MAX_SPEED*3.0/5.0
		
#		$"../Puck".transform.rotated(self.transform.get_rotation())
#		$Area2D.monitoring = true
#		$Area2D.set_deferred("monitoring", true)
#		$"../Puck".linear_velocity = puck_velocity
		($%Puck as RigidBody2D).apply_impulse(puck_velocity, Vector2.ZERO)
		$RemoteTransform2D.remote_path = NodePath("")
		
		var timer:SceneTreeTimer = self.get_tree().create_timer(0.1)
		timer.timeout.connect(func(): 
			$Area2D.set_deferred("monitoring", true)
			state = States.SKATE
			)



func _on_puck_body_entered(body):
	printt("Pick-up puck?:", body)

func _on_area_2d_area_entered(area):
	$RemoteTransform2D.remote_path = ^"../../Puck"
	$Area2D.set_deferred("monitoring", false) # https://godotengine.org/qa/63620/cant-set-area2d-scene-monitorable-property-false-via-script
	$%Puck.on_pickup(self)
	printt("Pick-up puck:", self, area)


