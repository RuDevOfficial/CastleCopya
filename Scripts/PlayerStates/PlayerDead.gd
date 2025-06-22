extends State
class_name PlayerDead
@export var _animationTree : AnimationTree
@export var _deadTimer : Timer
@export var _deadSound : FmodEventEmitter2D
var state_machine
@onready var sceneSwitcher = get_tree().root.get_node("Main").get_node("SceneSwitcher")

signal player_just_died
signal player_dead

func Enter() -> void:
	state_machine = _animationTree.get("parameters/playback")
	state_machine.travel("Dead")
	
	sceneSwitcher.on_level_begin_loading.connect(revive)
	
	_deadTimer.start(_playerResource.DeadTime)
	_deadSound.play_one_shot()
	player_just_died.emit()

func Exit() -> void:
	pass

func Update(_delta : float) -> void:
	pass

func Physics_Update(_delta : float) -> void:
	pass

func _on_dead_timer_timeout() -> void:
	player_dead.emit(false)

func revive(levelResource) -> void:
	state_machine.travel("Start")
	sceneSwitcher.on_level_begin_loading.disconnect(revive)
	Exiting.emit(self, "Normal")
