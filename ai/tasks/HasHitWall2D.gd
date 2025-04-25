@tool
extends BTCondition

var rigidBody2D : RigidBody2D

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Has Hit Wall 2D"

# Called to initialize the task.
func _setup() -> void:
	rigidBody2D = agent

# Called when the task is entered.
func _enter() -> void:
	pass

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	var collision : KinematicCollision2D = blackboard.get_var("collision")
	if (collision):
		if (collision.get_normal().x != 0):
			return SUCCESS
	
	return FAILURE

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
