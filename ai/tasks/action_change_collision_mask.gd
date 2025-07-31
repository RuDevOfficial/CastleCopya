@tool
extends BTAction

@export var node_path : NodePath
@export_flags_2d_physics var collision_mask

func _generate_name() -> String:
	return "Change Collision Mask"

func _tick(delta: float) -> Status:
	var node = agent.get_node(node_path)
	if (node == null): return FAILURE
	
	node.collision_mask = collision_mask
	return SUCCESS
