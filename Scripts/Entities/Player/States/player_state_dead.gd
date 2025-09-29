extends State
class_name PlayerDead
@export var _animationTree : AnimationTree
@export var _deadTimer : Timer
var state_machine

signal player_just_died
signal player_dead

func _ready() -> void:
	SignalBus.on_middle_transition.connect(revive)
	state_machine = _animationTree.get("parameters/playback")

func Enter() -> void:
	state_machine.travel("Dead")
	
	_deadTimer.start(player_resource.DeadTime)
	AudioManager.do_one_shot("Death")
	AudioManager.stop_music(true)

func _on_dead_timer_timeout() -> void:
	SignalBus.on_player_death.emit()

func revive(is_player_respawning) -> void:
	if (is_player_respawning == false): return
	
	state_machine.travel("Start")
	Exiting.emit(self, "Normal")
