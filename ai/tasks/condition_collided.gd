@tool

extends BTCondition

var rigidbody2D : RigidBody2D

func _generate_name() -> String:
	return "Has collided"

func _setup() -> void:
	rigidbody2D = agent

func _tick(delta: float) -> Status:
	
	if (rigidbody2D.get_colliding_bodies().size() != 0):
		return SUCCESS
	
	return FAILURE
