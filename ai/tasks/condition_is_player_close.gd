@tool

extends BTCondition

var player_reference : Node2D
@export var distance : float

func _generate_name() -> String:
	return "Is the distance between this and player " + str(distance) + "?"

func _setup() -> void:
	player_reference = agent.get_tree().get_first_node_in_group("player")

func _tick(delta: float) -> Status:
	var agent_position : Vector2 = agent.global_position
	var actual_distance : float = agent_position.distance_to(player_reference.global_position)
	if (actual_distance <= distance): return SUCCESS
	
	return FAILURE
