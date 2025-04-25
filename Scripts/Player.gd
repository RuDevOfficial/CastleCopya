extends CharacterBody2D
class_name PlayerCharacter

@export var _playerResource : PlayerResource
@export var _animationTree : AnimationTree
@onready var _FSM = $FSM

func _ready() -> void:
	_playerResource.SetDefaultValues()
	
	var gameController = get_tree().root.get_node("Main")
	gameController.on_load_level.connect(freeze_player)
	
	var sceneSwitcher = get_tree().root.get_node("Main").get_node("SceneSwitcher")
	sceneSwitcher.on_level_begin_loading.connect(reset_player)

func freeze_player(levelResource : LevelResource) -> void:
	if (levelResource.LookLeftOnLoad == false): 
		_playerResource.LastDirection =  1
	else:
		_playerResource.LastDirection = -1

	_animationTree.active = false
	_playerResource.CanMove = false

func reset_player(levelResource : LevelResource) -> void:
	global_position = levelResource.PlayerSpawnPosition
	velocity.x = 0
	_playerResource.CanMove = false

func _on_scene_switcher_on_level_finish_loading(levelResource : LevelResource) -> void:
	_animationTree.active = true
	_playerResource.CanMove = true

func get_state(name : String) -> Node:
	return get_node("FSM").get_node(name)
