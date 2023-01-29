extends RigidBody2D

func _ready():
	pass

func _on_body_entered(body):
	printt("Puck::_on_body_entered", body)
	pass


var last_player
func on_pickup(player):
	if last_player != player and last_player != null:
		last_player.puck_lost()
	last_player = player
	self.linear_velocity = Vector2.ZERO

func stop():
	last_player = null
	self.linear_velocity = Vector2.ZERO

