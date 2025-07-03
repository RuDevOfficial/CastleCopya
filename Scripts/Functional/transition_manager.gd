extends CanvasLayer
class_name TransitionManager

var already_transitioning : bool = false

@onready var animation_player : AnimationPlayer = $Control/AnimationPlayer

var state_transition_to : GStateManager.GameState = GStateManager.GameState.Ready

func _ready() -> void:
	set_process_input(false)
	set_process_shortcut_input(false)
	set_process_unhandled_input(false)

func try_transition(state : GStateManager.GameState) -> void:
	if (can_transition()):
		print("I did :D")
		state_transition_to = state
		already_transitioning = true
		begin_transition()

func can_transition() -> bool:
	return already_transitioning == false

func begin_transition() -> void:
	animation_player.play("start")
	SignalBus.on_begin_transition.emit()

# THESE METHODS ARE CALLED ON THE ANIMATION
func middle_transition() -> void:
	animation_player.play("end")
	GStateManager.change_state(state_transition_to)
	SignalBus.on_middle_transition.emit()

func end_transition() -> void:
	state_transition_to = GStateManager.GameState.Ready
	animation_player.play("RESET")
	already_transitioning = false
	SignalBus.on_end_transition.emit()
