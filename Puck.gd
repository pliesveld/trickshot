extends RigidBody2D

func _ready():
	pass

func _on_body_entered(body):
	printt("Puck::_on_body_entered", body)
	pass

func on_pickup(player):
	self.linear_velocity = Vector2.ZERO
