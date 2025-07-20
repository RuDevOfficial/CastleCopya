extends CharacterBody2D
class_name PlayerCharacter

@export var _playerResource : PlayerResource
@export var _animationTree : AnimationTree

@onready var _health : Health = $"Components/Health"

var last_spawn_position : Vector2

func _ready() -> void:
	_playerResource.SetDefaultValues(self)
	
	connect_signals()
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

func reset_player() -> void:
	global_position = last_spawn_position
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

func connect_signals() -> void:
	
	SignalBus.on_level_generated.connect(func(level_resource, level_instance):
		last_spawn_position = level_instance.get_node("PlayerSpawnPosition").global_position # SHOULD BE MODIFIED
		show_player()
		reset_player()
		activate_player())
	
	SignalBus.on_middle_transition.connect(func(is_player_respawning):
		if (is_player_respawning == false): return
		
		_health.set_health(_playerResource.StartingHealth)
		
		show_player()
		reset_player()
		)
	
	SignalBus.on_end_transition.connect(func(is_player_respawning):
		if (is_player_respawning == true): activate_player())
	
	SignalBus.on_clear_level.connect(func(): freeze_player(null))
	
	SignalBus.on_warp_entered.connect(
		func(position : Vector2, camera_path_index : int, 
		stair_path : Path2D, path_progress : float, is_entrance : bool): 
			if (_playerResource.IsOnStairs == true): return
			
			global_position = position
			# DO SOMETHING
			)
	
	# THIS IS ONLY FOR DEBUG PURPOSES
	SignalBus.on_debug_teleport_to_boss.connect(func():
		var paths_node_parent : Node2D = owner.get_node("Level").get_child(0).get_node("Paths")
		for path in paths_node_parent.get_children():
			if (path is not CameraPath): continue
			if (path.is_last_path == false): continue
			
			var cam_path : CameraPath = path
			global_position = cam_path.to_global(cam_path.curve.get_point_in(0))
			break
	)
