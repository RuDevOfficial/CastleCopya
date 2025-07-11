extends Node

var target_parent_node : Node2D

var level_list : Array[LevelResource]
@export var current_level_index : int = 0
var current_level_instance : Node2D

var orb_scene : PackedScene
var orb_spawn_position : Vector2

func _ready() -> void:
	var list = ResourceLoader.list_directory("res://Resources/Levels/")
	for item in list:
		var resource : LevelResource = ResourceLoader.load("res://Resources/Levels/" + item)
		level_list.push_back(resource)
	
	target_parent_node = get_tree().root.get_node("Main/Level")
	orb_scene = preload("res://Scenes/Consumables/orb.tscn")
	
	current_level_index = SaveManager.get_current_gameplay_data().CURRENT_LEVEL
	
	SignalBus.on_reach_last_camera_path.connect(generate_end_event)
	SignalBus.on_middle_transition.connect(play_level_music)
	SignalBus.on_clear_level.connect(increase_current_level)
	SaveManager.on_clear_gameplay_data.connect(func(): current_level_index = 0)

func generate_new_level(new_index : int) -> void:
	if(current_level_instance != null): current_level_instance.queue_free()
	var level_resource : LevelResource = level_list[current_level_index]
	
	current_level_instance = level_resource.level_scene.instantiate()
	target_parent_node.add_child(current_level_instance)
	orb_spawn_position = current_level_instance.get_node("OrbSpawnPosition").global_position
	
	current_level_index = new_index
	MusManager.play_music(get_current_level_resource().LevelMusicID)
	SignalBus.on_level_generated.emit(level_resource, current_level_instance)

func increase_current_level() -> void:
	current_level_index = clampi(current_level_index + 1, 0, level_list.size() - 1)
	SaveManager.overwrite_current_gameplay_data_values("CURRENT_LEVEL", current_level_index, true)

func generate_end_event() -> void:
	match get_current_level_resource().StageEndEvent:
		LevelResource.EndEvent.None: 
			var new_orb : Node2D = orb_scene.instantiate()
			new_orb.global_position = orb_spawn_position
			current_level_instance.add_child(new_orb)
		LevelResource.EndEvent.Boss: pass

func get_current_level_resource() -> LevelResource:
	return level_list[current_level_index]

func play_level_music(is_player_respawning : bool) -> void:
	if (is_player_respawning == true):
		MusManager.play_music(get_current_level_resource().LevelMusicID)
