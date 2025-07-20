@tool

extends BTAction

@export var target_position_key : String
@export var speed_key : String

var target_pos : Vector2
var speed : float
var vector_director : Vector2

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Go To Position (2D)"

# Called to initialize the task.
func _setup() -> void:
	pass

# Called when the task is entered.
func _enter() -> void:
	target_pos = blackboard.get_var(target_position_key)
	vector_director = (target_pos - agent.global_position).normalized()

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	agent.move_and_collide((vector_director * speed) * delta)
	
	speed = blackboard.get_var(speed_key)
	
	var new_vector_direction = (target_pos - agent.global_position).normalized()
	var vector_length = (target_pos - agent.global_position).length()
	
	if (vector_director.dot(new_vector_direction) < 0):
		agent.move_and_collide(new_vector_direction * vector_length)
		return SUCCESS
	
	return RUNNING

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
