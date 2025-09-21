@tool 

extends BTAction

var vertical_tween : Tween

@export var trans_type : Tween.TransitionType
@export var ease_type : Tween.EaseType
@export var starts_up : bool
@export var distance : float

@export var tween_time : float

func _setup() -> void:
	vertical_tween = agent.get_tree().create_tween().set_loops()
	vertical_tween.set_trans(trans_type)
	vertical_tween.set_ease(ease_type)
	
	if (starts_up == true):
		vertical_tween.tween_property(agent, "global_position:y", agent.global_position.y - distance * 2, tween_time)
		vertical_tween.tween_property(agent, "global_position:y", agent.global_position.y, tween_time)		
	else: 
		vertical_tween.tween_property(agent, "global_position:y", agent.global_position.y + distance, tween_time)
		vertical_tween.tween_property(agent, "global_position:y", agent.global_position.y, tween_time)

func _enter() -> void:
	vertical_tween.play()

func _exit() -> void:
	vertical_tween.stop()

func _tick(delta: float) -> Status:
	return RUNNING
