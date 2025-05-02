extends CharacterBody2D
class_name PlayerCharacter

@export var _playerResource : PlayerResource
@export var _animationTree : AnimationTree

signal on_subweapon_changed
signal on_subweapon_used_trigger
signal on_player_start

func _ready() -> void:
	_playerResource.SetDefaultValues(self)
	
	var gameController = get_tree().root.get_node("Main")
	gameController.on_load_level.connect(freeze_player)
	gameController.on_load_level_early.connect(_on_scene_switcher_on_level_finish_loading)
	
	var sceneSwitcher = get_tree().root.get_node("Main").get_node("SceneSwitcher")
	sceneSwitcher.on_level_begin_loading.connect(reset_player)
	
	update_subweapon(_playerResource.CurrentSubweapon)
	on_player_start.emit(_playerResource)

func _process(delta: float) -> void:
	if (_playerResource.SubweaponUsedTrigger == true):
		on_subweapon_used_trigger.emit(_playerResource)
		_playerResource.SubweaponUsedTrigger = false

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

func get_state(new_name : String) -> Node:
	return get_node("FSM").get_node(new_name)

func update_subweapon(new_subweapon : SubweaponDataResource):
	on_subweapon_changed.emit(new_subweapon)
