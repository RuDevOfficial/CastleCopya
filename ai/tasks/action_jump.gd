@tool

extends BTAction

var rigidbody2D : RigidBody2D
@export var jump_force : float
var direction : int

@export var speed_key : String
var speed : float

func _generate_name() -> String:
	return "Jump, Move and Wait to Collide"

func _setup() -> void:
	rigidbody2D = agent

func _enter() -> void:
	direction = blackboard.get_var("direction")
	speed = blackboard.get_var(speed_key)
	
	rigidbody2D.linear_velocity = Vector2.UP * jump_force

func _tick(delta: float) -> Status:
	var collision : KinematicCollision2D = rigidbody2D.move_and_collide(Vector2.RIGHT * (direction * (speed * delta)))
	if (collision != null): 
		return SUCCESS
	
	return RUNNING
