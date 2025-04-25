@tool
extends BTAction

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.

@export var spriteLooksRight : bool
var sprite2D : Sprite2D

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Flip Sprite from Direction"

# Called to initialize the task.
func _setup() -> void:
	sprite2D = agent.get_node("Sprite")

# Called when the task is entered.
func _enter() -> void:
	pass

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if (sprite2D == null):
		return FAILURE
		
	var direction = blackboard.get_var("direction")
	
	if (spriteLooksRight == false):
		if (direction == 1):
			sprite2D.flip_h = true
		elif (direction == -1):
			sprite2D.flip_h = false
	else:
		if (direction == 1):
			sprite2D.flip_h = false
		elif (direction == -1):
			sprite2D.flip_h = true
	
	return SUCCESS

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
