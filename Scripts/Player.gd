extends CharacterBody2D
class_name PlayerCharacter

@export var _playerResource : PlayerResource
@export var _animationTree : AnimationTree

@onready var _health : Health = $"Components/Health"

func _ready() -> void:
	_playerResource.SetDefaultValues(self)
	
	SignalBus.on_level_generated.connect(func(level_resource):
		show_player()
		reset_player(level_resource)
		activate_player())
	
	#var gameController = get_tree().root.get_node("Main")
	#gameController.on_load_level.connect(freeze_player)
	#gameController.on_load_level_early.connect(_on_scene_switcher_on_level_finish_loading)
	#
	#var sceneSwitcher = get_tree().root.get_node("Main/Managers/SceneSwitcher")
	#sceneSwitcher.on_level_begin_loading.connect(reset_player)
	
	freeze_player(null)
	hide_player()

func freeze_player(levelResource : LevelResource) -> void:
	if (levelResource != null):
		if (levelResource.LookLeftOnLoad == false): _playerResource.LastDirection =  1
		else: _playerResource.LastDirection = -1
	
	_animationTree.active = false
	_playerResource.CanMove = false

func hide_player() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	set_physics_process(false)
	disable_mode = CollisionObject2D.DISABLE_MODE_MAKE_STATIC
	visible = false

func show_player() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	set_physics_process(true)
	disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	visible = true

func reset_player(levelResource : LevelResource) -> void:
	global_position = levelResource.PlayerSpawnPosition
	velocity.x = 0
	_playerResource.CanMove = false

func activate_player() -> void:
	_animationTree.active = true
	_playerResource.CanMove = true
	show_player()

func _on_scene_switcher_on_level_finish_loading(levelResource : LevelResource) -> void:
	_health._current = _playerResource.StartingHealth
	activate_player()

func get_state(new_name : String) -> Node:
	return get_node("FSM").get_node(new_name)
