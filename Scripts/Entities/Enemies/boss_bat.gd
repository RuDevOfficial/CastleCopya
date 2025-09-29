extends Boss

@export var horizontal_attack_distance : float
@export var attack_duration : float

var start_attack_position :  Vector2

var player_reference : Node2D
@export var attack_y_offset : float

func set_ready_values() -> void:
	player_reference = get_tree().get_first_node_in_group("player")

func attack() -> void:
	start_attack_position = global_position
	
	var target_x_position : float = get_target_x_position()
	var target_y_position : float = get_target_y_position()
	
	var horizontal_tween : Tween = get_tree().create_tween()
	horizontal_tween.tween_property(self, "global_position:x", target_x_position, attack_duration)
	
	var vertical_tween : Tween = get_tree().create_tween()
	vertical_tween.set_ease(Tween.EASE_OUT)
	vertical_tween.set_trans(Tween.TRANS_QUAD)
	vertical_tween.tween_property(self, "global_position:y", target_y_position - attack_y_offset, attack_duration / 2.0)
	vertical_tween.tween_callback(func():
		
		var second_vertical_tween : Tween = get_tree().create_tween()
		second_vertical_tween.set_ease(Tween.EASE_IN)
		second_vertical_tween.set_trans(Tween.TRANS_QUAD)
		second_vertical_tween.tween_property(self, "global_position:y", start_attack_position.y, attack_duration / 2.0)
		)
	
	
	await horizontal_tween.finished
	behavior_reference.blackboard.set_var("attacking", false)

func get_target_x_position() -> float:
	var target_pos : float
	
	var direction_to_player_on_x : float = global_position.direction_to(player_reference.global_position).x 
	if (direction_to_player_on_x > 0): target_pos = global_position.x + horizontal_attack_distance
	else: target_pos = global_position.x - horizontal_attack_distance
	
	return target_pos

func get_target_y_position() -> float:
	return player_reference.global_position.y
