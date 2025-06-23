@tool

extends BTAction

func _generate_name() -> String:
	return "Change Direction to Target"

func _tick(delta: float) -> Status:
	var target : Node2D = agent.get_tree().get_first_node_in_group("player")
	if (target == null): return FAILURE
	
	if (target.global_position.x > agent.global_position.x): blackboard.set_var("direction", 1)
	else: blackboard.set_var("direction", -1)
	
	return SUCCESS
