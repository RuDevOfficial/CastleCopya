@tool
extends BTAction

@export var _valueName : String

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Invert Numerical Value"

# Called to initialize the task.
func _setup() -> void:
	pass

# Called when the task is entered.
func _enter() -> void:
	pass

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	var value = blackboard.get_var(_valueName)
	if (value):
		value *= -1
		blackboard.set_var(_valueName, value)
		return SUCCESS
	
	return FAILURE

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
