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
	
func reset():
	$AnimationTree.active = false
	self.set_physics_process(false)
	self.velocity = Vector2.ZERO
	self.dir = Direction.EAST
	self.rotation_degrees = 0
	self.velocity = Vector2.ZERO
	$RemoteTransform2D.remote_path = NodePath("")
	

func _physics_process(delta):
	var input_y = Input.get_action_strength("player1_down") - Input.get_action_strength("player1_up")
	var input_x = Input.get_action_strength("player1_right") - Input.get_action_strength("player1_left")

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
	
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	$AnimationTree.set("parameters/skate_animation_timescale/scale", maxf(6.5*absf(velocity.x)/MAX_SPEED,6.5*absf(velocity.y)/MAX_SPEED))
	
	
	if Input.get_action_strength("player1_shoot", true) and $RemoteTransform2D.remote_path != NodePath(""):
		state = States.SHOOT
		$AnimationTree["parameters/shoot/active"] = true

#		var puck_velocity = (Vector2(input_y * speed * delta, input_x * speed * delta) * speed * 0.7) # (self.velocity * 4.0 * 0.3) + 
#		$"../puck".linear_velocity = puck_velocity
#		$"../puck".linear_velocity = Vector2.RIGHT * 8*MAX_SPEED
		
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
		
		
		puck_velocity *= 3.2*MAX_SPEED
		
#		$"../puck".transform.rotated(self.transform.get_rotation())
		$"../puck".linear_velocity = puck_velocity
		$RemoteTransform2D.remote_path = NodePath("")



func _on_puck_body_entered(body):
	printt("Pick-up puck:", body)

func _on_area_2d_area_entered(area):
	$RemoteTransform2D.remote_path = ^"../../puck"
	$"../puck".linear_velocity = Vector2.ZERO
	printt("Pick-up puck:", area)


