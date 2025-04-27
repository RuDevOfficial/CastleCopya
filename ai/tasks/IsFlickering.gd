@tool
extends BTCondition

var _flicker : Flicker

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Is Flickering?"

# Called to initialize the task.
func _setup() -> void:
	_flicker = agent.get_node("Components/Flicker")

# Called when the task is entered.
func _enter() -> void:
	pass

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if (_flicker.Flickering == true):
		return SUCCESS
	
	return FAILURE

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
