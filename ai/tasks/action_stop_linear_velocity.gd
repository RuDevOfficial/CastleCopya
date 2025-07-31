@tool
extends BTAction

func _generate_name() -> String:
	return "Stop Linear Velocity"

func _tick(delta: float) -> Status:
	var rigidbody : RigidBody2D = agent
	if (rigidbody == null): return FAILURE
	
	rigidbody.linear_velocity = Vector2.ZERO
	return SUCCESS
