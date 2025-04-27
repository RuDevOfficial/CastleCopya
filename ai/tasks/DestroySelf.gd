@tool
extends BTAction

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Destroy Self"

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
	agent.queue_free()
	return SUCCESS

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
