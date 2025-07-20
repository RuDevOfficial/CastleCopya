@tool

extends BTAction

@export var original_position_key : String
@export var stored_position_key : String

@export var x_range : Vector2
@export var y_range : Vector2

@export_category("Options")
@export var min_distance_required : bool
@export var min_distance_requirement : float


# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Store Random Position in Area (2D)"

# Called when the task is entered.
func _enter() -> void:
	pass

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	var starting_position : Vector2 = blackboard.get_var(original_position_key)
	
	var target_position : Vector2 = Vector2.ZERO
	var target_position_obtained : bool = false
	
	while(target_position_obtained == false):
		var random_x_pos : float = randf_range(starting_position.x - x_range[0] , starting_position.x + x_range[1])
		var random_y_pos : float = randf_range(starting_position.y - y_range[0] , starting_position.y + y_range[1])
		
		target_position = Vector2(random_x_pos, random_y_pos)
		
		# WON'T LEAVE LOOP UNTIL THE REQUIRED MINIMUM DISTANCE IS MET
		if (min_distance_required):
			if (target_position.distance_to(agent.global_position) > min_distance_requirement):
				target_position_obtained = true
	
	blackboard.set_var(stored_position_key, target_position)
	
	return SUCCESS

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
