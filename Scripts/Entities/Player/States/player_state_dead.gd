extends State
class_name PlayerDead

@export var _animationTree : AnimationTree
@export var _deadTimer : Timer

var state_machine

signal player_just_died
signal player_dead

func _ready() -> void:
	SignalBus.on_middle_transition.connect(revive)

func Enter() -> void:
	_animationTree.get("parameters/playback").travel("Dead")
	
	_deadTimer.start(player_resource.DeadTime)
	
	AudioManager.do_one_shot("Death")
	AudioManager.stop_music(true)

# This event fires the necessary logic for a transition between
# the dark screen, a reset, and a replayable state.

# It is recommended to see which signals are connected on each signal
# inside this SignalBus global class to understand it better
func _on_dead_timer_timeout() -> void:
	SignalBus.on_player_death.emit()

func revive(is_player_respawning) -> void:
	if (is_player_respawning == false): return
	
	_animationTree.get("parameters/playback").travel("Start")
	Exiting.emit(self, "Normal")
