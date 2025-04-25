extends Node
class_name SceneSwitcher

@onready var _loadTimer : Timer = $LoadTimer
@onready var _animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var _label : Label = $"UI Layer/Label"
@export var _waitTime : float

@export var _levelName : String
@export var _fullTextTimeOffset : float
var _timePerChar : float

var _lastLevelResource : LevelResource

signal on_level_finish_loading
signal on_level_begin_loading

func start_transition(levelResource) -> void:
	_lastLevelResource = levelResource
	_timePerChar =  (_waitTime - _fullTextTimeOffset) / _levelName.length()
	_label.text = ""
	_animationPlayer.play("fade_in")

func start_transition_noFadeIn(levelResource)  -> void:
	_lastLevelResource = levelResource
	_timePerChar =  (_waitTime - _fullTextTimeOffset) / _levelName.length()
	_label.text = ""
	_animationPlayer.play("inbetween")
	begin_load_timer()

# This gets triggered once the fade_in ends
func begin_load_timer() -> void:
	on_level_begin_loading.emit(_lastLevelResource)
	_loadTimer.start(_waitTime)
	for char in _levelName:
		await get_tree().create_timer(_timePerChar).timeout
		_label.text += char

# This gets triggered once the loading timer ends
func _on_load_timer_timeout() -> void:
	#call level loader to change level and resource and stuff
	_animationPlayer.play("fade_out")

func end_transition():
	#call a signal to tell the level has finished loading
	on_level_finish_loading.emit(_lastLevelResource)
