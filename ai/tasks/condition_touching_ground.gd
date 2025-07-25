@tool
extends BTCondition

var space_state : PhysicsDirectSpaceState2D
var direction : int
@export var size : float
@export var ray_length : float
@export_flags_2d_physics var collision_mask

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Is Touching Ground"

func _enter() -> void:
	direction = blackboard.get_var("direction")

func _setup() -> void:
	space_state = agent.get_world_2d().direct_space_state

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	
	var query_left : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		agent.global_position + Vector2.LEFT * size/2.0, 
		agent.global_position + (Vector2.DOWN * ray_length),
		collision_mask,
		[self])
		
	var query_right : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		agent.global_position + Vector2.RIGHT * size/2.0, 
		agent.global_position + (Vector2.DOWN * ray_length),
		collision_mask,
		[self])
	
	var result_left = space_state.intersect_ray(query_left)
	var result_right = space_state.intersect_ray(query_right)
	
	if (result_left.size() == 0 && result_right.size() == 0): 
		return FAILURE
	
	return SUCCESS

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
