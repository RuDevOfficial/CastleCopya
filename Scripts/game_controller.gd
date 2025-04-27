extends Node2D
class_name GameController

@export var _startWithLoading : bool = false
@export var _gameCamera : Camera2D
@export var _levelResource : LevelResource
@onready var _musicEmitter : SimpleMusicManager = $MusicEmitter
@onready var _playerCharacter : PlayerCharacter = $Player
@onready var _sceneSwitcher : SceneSwitcher = $SceneSwitcher

signal on_load_level
signal on_load_level_early

func _ready() -> void:
	on_load_level.emit(_levelResource)
	_playerCharacter.get_state("Dead").player_dead.connect(_restart_level)
	if (_startWithLoading == true):
		_load_level()
	else:
		_load_level_instantly()

func _restart_level() -> void:
	_sceneSwitcher.start_transition(_levelResource)

func _load_level() -> void:
	if (_levelResource.RequiresFadeIn):
		_sceneSwitcher.start_transition(_levelResource)
	else:
		_sceneSwitcher.start_transition_noFadeIn(_levelResource)

func _load_level_instantly() -> void:
	on_load_level_early.emit(_levelResource)
	_musicEmitter.play_music(_levelResource.LevelMusicID)
