extends Node
class_name SceneSwitcher
# UNUSED CLASS FROM A PREVIOUS TIME, CAN DELETE
# This class generates a transition with a title name, usually the
# level's actual name.

@onready var load_timer : Timer = $LoadTimer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var label : Label = $"UI Layer/Label"
@export var wait_time : float # The amount of time it should take to show the name

@export var level_name : String
@export var full_text_time_offset : float # The time it takes after the complete name has been shown
var time_per_character : float

var _lastLevelResource : LevelResource

var _isFirstTransition : bool = true

signal on_level_finish_loading
signal on_level_fading_completed
signal on_level_begin_loading

func start_transition(levelResource, firstTime) -> void:
	_lastLevelResource = levelResource
	time_per_character =  (wait_time - full_text_time_offset) / level_name.length()
	label.text = ""
	animation_player.play("fade_in")
	
	_isFirstTransition = firstTime

func start_transition_noFadeIn(levelResource, firstTime)  -> void:
	_lastLevelResource = levelResource
	time_per_character =  (wait_time - full_text_time_offset) / level_name.length()
	label.text = ""
	animation_player.play("inbetween")
	begin_load_timer(firstTime)
	
	_isFirstTransition = firstTime

# This gets triggered once the fade_in ends
func begin_load_timer(firstTime : bool = true) -> void:
	on_level_begin_loading.emit(_lastLevelResource)
	if (_isFirstTransition): load_timer.start(wait_time)
	else:
		AudioManager.play_music(_lastLevelResource.LevelMusicID)
		on_level_fading_completed.emit()
		SignalBus.on_level_fade_completed.emit()
		animation_player.play("fade_out")
	
	if (_isFirstTransition == true):
		for character in level_name:
			await get_tree().create_timer(time_per_character).timeout
			label.text += character

# This gets triggered once the loading timer ends
func _on_load_timer_timeout() -> void:
	#call level loader to change level and resource and stuff
	AudioManager.play_music(_lastLevelResource.LevelMusicID)
	SignalBus.on_level_fade_completed.emit()
	on_level_fading_completed.emit()
	animation_player.play("fade_out")

func end_transition():
	#call a signal to tell the level has finished loading
	SignalBus.on_level_finish_load.emit(_lastLevelResource)
	on_level_finish_loading.emit(_lastLevelResource)
