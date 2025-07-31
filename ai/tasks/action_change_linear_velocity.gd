@tool 
extends BTAction

@export var vector_key : String
var rigidbody : RigidBody2D

func _generate_name() -> String:
	return "Change Linear Velocity"

func _setup() -> void:
	rigidbody = agent

func _tick(delta: float) -> Status:
	var vector : Vector2 = blackboard.get_var(vector_key)
	if (vector == Vector2.ZERO): return FAILURE
	
	rigidbody.linear_velocity = vector
	
	return SUCCESS
