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
	
	SignalBus.on_reach_last_camera_path.connect(generate_end_event)

func generate_new_level(new_index : int) -> void:
	if(current_level_instance != null): current_level_instance.queue_free()
	var level_resource : LevelResource = level_list[current_level_index]
	
	current_level_instance = level_resource.level_scene.instantiate()
	target_parent_node.add_child(current_level_instance)
	orb_spawn_position = current_level_instance.get_node("OrbSpawnPosition").global_position
	
	current_level_index = new_index
	MusManager.play_music(level_resource.LevelMusicID)
	print(current_level_instance != null)
	SignalBus.on_level_generated.emit(level_resource, current_level_instance)

func increase_current_level() -> void:
	current_level_index = clampi(current_level_index + 1, 0, level_list.size() - 1)

func generate_end_event() -> void:
	match get_current_level_resource().StageEndEvent:
		LevelResource.EndEvent.None: 
			var new_orb : Node2D = orb_scene.instantiate()
			new_orb.global_position = orb_spawn_position
			current_level_instance.add_child(new_orb)
		LevelResource.EndEvent.Boss: pass

func get_current_level_resource() -> LevelResource:
	return level_list[current_level_index]
