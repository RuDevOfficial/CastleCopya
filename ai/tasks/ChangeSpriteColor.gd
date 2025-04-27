@tool
extends BTAction

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.

var _sprite2D : Sprite2D
@export var _color : Color

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Change Sprite Color"

# Called to initialize the task.
func _setup() -> void:
	_sprite2D = agent.get_node("Sprite")

# Called when the task is entered.
func _enter() -> void:
	pass

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if (_sprite2D == null):
		return FAILURE
	
	_sprite2D.modulate = _color
	return SUCCESS

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
