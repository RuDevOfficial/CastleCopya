@tool
extends BTCondition

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.

var _health : Health

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Is Health Zero"

# Called to initialize the task.
func _setup() -> void:
	_health = agent.get_node("Components/Health")

# Called when the task is entered.
func _enter() -> void:
	pass

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if (_health.get_current() <= 0):
		return SUCCESS
	
	return FAILURE

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
