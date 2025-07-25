@tool
extends BTAction

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.

var rigidBody2D : RigidBody2D
var direction : float
@export var speed_key : String

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Linear Move 2D"

# Called to initialize the task.
func _setup() -> void:
	rigidBody2D = agent

# Called when the task is entered.
func _enter() -> void:
	direction = blackboard.get_var("direction")

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	var speed = blackboard.get_var(speed_key)
	var xVelocity : float = (direction * (speed * delta))
	
	rigidBody2D.move_and_collide(Vector2(xVelocity, 0))
	
	return RUNNING

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
