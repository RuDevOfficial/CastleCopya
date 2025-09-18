extends Node

var is_active : bool = false

signal on_start_gameplay_transition
signal on_middle_gameplay_transition
signal on_end_gameplay_transition

func _ready() -> void:
	# CONNECT SIGNALS
	GStateManager.on_enter_gameplay.connect(func(): is_active = true)
	GStateManager.on_exit_gameplay.connect(func(): is_active = false)
	
	SignalBus.on_player_death.connect(try_start_transition)
	
	#SignalBus.on_clear_level.connect(func(): )

func try_start_transition() -> void:
	if (can_start_transition()):
		start_transition()

func can_start_transition() -> bool: return is_active == true

func start_transition() -> void:
	on_start_gameplay_transition.emit()
