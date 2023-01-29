extends PlayerBase


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var navigation_agent_2d = $NavigationAgent2D

#enum States {
#	IDLE = 0,
#	SKATE = 1,
#	SHOOT = 2,
#}

func _ready():
	super()
	
var targetNode

func start():
	super()
	targetNode = $%Puck
	update_target()
	navigation_agent_2d.target_reached.connect(func(): self.player_shoot())

func player_shoot():
	if $RemoteTransform2D.remote_path != NodePath(""):
		super()	

func puck_lost():
	super()
	state = States.SKATE

func update_target():
	match state:
		States.SKATE:
			targetNode = $%Puck
		States.SHOOT:
			targetNode = $%Marker2D
	navigation_agent_2d.set_target_location(targetNode.position)

var total:float = 0.0

func _physics_process(delta):
	input_y = randf_range(-1.0,1.0)
	input_x = randf_range(-1.0,1.0)

	total += delta
	if total > 1.0:
		total = 0.0
		update_target()

	super(delta)
	
	var next_location = navigation_agent_2d.get_next_location()
	var direction = (next_location - global_transform.origin).normalized()
	velocity = velocity.move_toward(direction * SPEED, 540 * delta)
	

func _on_area_2d_area_entered(area):
	super(area)
	state = States.SHOOT
	update_target()
