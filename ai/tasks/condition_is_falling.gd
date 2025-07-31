@tool 
extends BTCondition

var rigidbody : RigidBody2D
var last_vertical_velocity : float

func _generate_name() -> String:
	return "Is Actor Falling?"
	

func _setup() -> void:
	rigidbody = agent

func _tick(delta: float) -> Status:
	if (rigidbody == null): return FAILURE
	var is_falling : bool
	
	if (rigidbody.linear_velocity.y > 0 && last_vertical_velocity < 0): is_falling = true
	last_vertical_velocity = rigidbody.linear_velocity.y
	
	if (is_falling == true): return SUCCESS
	else: return FAILURE
