extends Node
class_name StageLoader

@export var target_parent_node : Node2D

@export var level_list : Array[LevelResource]

@export var current_level_index : int = 0
var current_level_instance : Node2D

func generate_new_level(new_index : int) -> void:
	if(current_level_instance != null): current_level_instance.queue_free()
	var level_resource : LevelResource = level_list[current_level_index]
	
	current_level_instance = level_resource.level_scene.instantiate()
	target_parent_node.add_child(current_level_instance)
	
	current_level_index = new_index
	MusManager.play_music(level_resource.LevelMusicID)
	SignalBus.on_level_generated.emit(level_resource)
