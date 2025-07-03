extends CanvasLayer
class_name TransitionManager

var already_transitioning : bool = false

@onready var animation_player : AnimationPlayer = $Control/AnimationPlayer

var last_transition_state : GStateManager.GameState = GStateManager.GameState.Ready
var is_player_respawning : bool = false

func _ready() -> void:
	set_process_input(false)
	set_process_shortcut_input(false)
	set_process_unhandled_input(false)
	
	GameplayManager.on_start_gameplay_transition.connect(try_transition_in_gameplay)

func try_transition(state : GStateManager.GameState) -> void:
	if (can_transition()):
		is_player_respawning = false
		last_transition_state = state
		already_transitioning = true
		begin_transition()

func try_transition_in_gameplay() -> void:
	if (can_transition()):
		is_player_respawning = true
		already_transitioning = true
		begin_transition()

func can_transition() -> bool:
	return already_transitioning == false

func begin_transition() -> void:
	animation_player.play("start")
	SignalBus.on_begin_transition.emit(is_player_respawning)

# THESE METHODS ARE CALLED ON THE ANIMATION
func middle_transition() -> void:
	animation_player.play("end")
	if(is_player_respawning == false): GStateManager.change_state(last_transition_state)
	SignalBus.on_middle_transition.emit(is_player_respawning)

func end_transition() -> void:
	last_transition_state = GStateManager.GameState.Ready
	animation_player.play("RESET")
	already_transitioning = false
	SignalBus.on_end_transition.emit(is_player_respawning)
