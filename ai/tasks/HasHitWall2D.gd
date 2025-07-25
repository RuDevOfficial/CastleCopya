@tool
extends BTCondition

var space_state : PhysicsDirectSpaceState2D
var rigidBody2D : RigidBody2D
var direction : int
@export var ray_length : float
@export_flags_2d_physics var collision_mask

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Has Hit Wall 2D"

# Called to initialize the task.
func _setup() -> void:
	rigidBody2D = agent
	space_state = agent.get_world_2d().direct_space_state

func _enter() -> void:
	direction = blackboard.get_var("direction")

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	var query : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		agent.global_position, 
		agent.global_position + Vector2.RIGHT * (direction * ray_length),
		collision_mask,
		[self])
	var result = space_state.intersect_ray(query)
	if (result.size() != 0): return SUCCESS
	
	return FAILURE

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
