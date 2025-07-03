extends Node

@export var camera : Camera2D
@export var level_parent : Node2D
@export var player : Node2D

var level_path_list : Array[Path2D]
var current_path_index : int = 0
var current_end_point : Vector2
var current_camera_direction : CameraDirection = CameraDirection.None

func _ready() -> void:
	SignalBus.on_level_generated.connect(get_paths)

func _process(delta: float) -> void:
	match current_camera_direction:
		CameraDirection.None: pass
		CameraDirection.Horizontal: camera.global_position.x = player.global_position.x
		CameraDirection.Vertical: camera.global_position.y = player.global_position.y

func get_paths(resource : LevelResource, instance : Node2D):
	get_new_path_list(instance.get_node("CameraPath"))
	get_starting_path()

func get_new_path_list(path_node : Node2D) -> void:
	for child in path_node.get_children():
		if (child is not Path2D): continue
		
		level_path_list.push_back(child)

func get_starting_path() -> void:
	current_path_index = 0
	constrict_camera(0)

func next_path() -> void:
	var next_path_index = clampi(current_path_index + 1, 0, level_path_list.size())
	if (current_path_index == next_path_index): return
	
	constrict_camera(current_path_index)

func constrict_camera(index : int) -> void:
	var current_path : Path2D = level_path_list[index]
	
	var start_point : Vector2 = current_path.to_global(current_path.curve.get_point_position(0))
	var end_point : Vector2 = current_path.to_global(current_path.curve.get_point_position(1))
	
	var start_point_distance : float = (start_point - player.global_position).length()
	var end_point_distance : float = (end_point - player.global_position).length()
	
	current_end_point = end_point
	
	if (start_point_distance < end_point_distance): camera.global_position = start_point
	else: camera.global_position = end_point
	
	var path_vector : Vector2 = (end_point - start_point).normalized()
	if (path_vector.x != 0):
		if (path_vector.x > 0):
			camera.limit_left = start_point.x
			camera.limit_right = end_point.x
		else:
			camera.limit_left = end_point.x
			camera.limit_right = start_point.x
			
		camera.limit_top = start_point.y - 88
		camera.limit_bottom = start_point.y + 88
		current_camera_direction = CameraDirection.Horizontal

enum CameraDirection { None, Horizontal, Vertical }
