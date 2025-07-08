extends Node

@export var camera : Camera2D
@export var level_parent : Node2D
@export var player : Node2D

var following_player : bool = true
var can_follow_player : bool = false

var level_path_list : Array[CameraPath]
@export var current_path_index : int = 0
var current_end_point : Vector2
var current_camera_direction : CameraDirection = CameraDirection.None
var current_path_vector : Vector2

var transition_direction_vector : Vector2
var transition_from_position : Vector2
var transition_to_position : Vector2

var transitioning : bool = false

func _ready() -> void:
	SignalBus.on_level_generated.connect(get_paths)
	
	SignalBus.on_door_transition_camera_transition_start.connect(transition_to_next_path)
	
	GStateManager.on_enter_gameplay.connect(func(): can_follow_player = true)
	GStateManager.on_exit_gameplay.connect(func(): can_follow_player = false)

func disable_camera_follow(door : Door) -> void:
	following_player = false
	if (current_path_index == level_path_list.size() - 1): return

func transition_to_next_path() -> void:
	if (current_path_index + 1 > level_path_list.size() - 1): return
	
	var current_path = level_path_list[current_path_index]
	var path_position_start : Vector2 = current_path.to_global(current_path.curve.get_point_position(1))
	transition_from_position = path_position_start
	
	var next_path = level_path_list[current_path_index + 1]
	var path_position_end : Vector2 = next_path.to_global(next_path.curve.get_point_position(0))
	transition_to_position = path_position_end
	
	transition_direction_vector = (path_position_end - path_position_start).normalized()
	camera.global_position = path_position_start
	
	# RESETING TO DEFAULT VALUES
	if (transition_direction_vector.x > 0):
		camera.limit_left = path_position_start.x - 160
		camera.limit_right = path_position_end.x + 160
	else:
		camera.limit_left = path_position_end.x - 160
		camera.limit_right = path_position_start.x + 160
	
	transitioning = true

func enable_camera_follow() -> void:
	following_player = true
	next_path()

func _process(delta: float) -> void:
	if (following_player == false || can_follow_player == false): return
	
	if (transitioning == true):
		camera.global_position += (transition_direction_vector * (delta * 100))
		var new_vector : Vector2 = (transition_to_position - camera.global_position).normalized()
		
		if (transition_direction_vector.dot(new_vector) != 1):
			SignalBus.on_door_transition_finish.emit()
			transitioning = false
			next_path()
			
			if (current_path_index == level_path_list.size() - 1):
				SignalBus.on_reach_last_camera_path.emit()
	else:
		match current_camera_direction:
			CameraDirection.None: return
			CameraDirection.Horizontal: camera.global_position.x = player.global_position.x
			CameraDirection.Vertical: camera.global_position.y = player.global_position.y - 24
		
		check_for_path_connections()

func check_for_path_connections() -> void:
	# CHECKING FOR NEXT PATH IF IT CAN CONNECT
	var new_vector : Vector2 = (transition_to_position - camera.global_position).normalized()
	if (transition_direction_vector.dot(new_vector) < 0.99 && level_path_list[current_path_index].connects_to_next_path == true):
		next_path()
		return
		
	# CHECKING FOR PREVIOUS PATH IF IT CAN CONNECT
	new_vector = (transition_from_position - camera.global_position).normalized()
	if (-transition_direction_vector.dot(new_vector) < 0.99
	&& level_path_list[current_path_index].connects_to_previous_path == true):
		previous_path()
		return

func get_paths(resource : LevelResource, instance : Node2D):
	get_new_path_list(instance.get_node("CameraPath"))
	get_starting_path()

func get_new_path_list(path_node : Node2D) -> void:
	
	level_path_list.clear()
	
	for child in path_node.get_children():
		if (child is not Path2D): continue
		
		level_path_list.push_back(child)

func get_starting_path() -> void:
	current_path_index = 0
	constrict_camera(0)

func next_path() -> void:
	var next_path_index = clampi(current_path_index + 1, 0, level_path_list.size() - 1)
	if (current_path_index == next_path_index): return
	current_path_index = next_path_index
	
	constrict_camera(current_path_index)

func previous_path() -> void:
	var previous_path_index = clampi(current_path_index - 1, 0, level_path_list.size() - 1)
	if (current_path_index == previous_path_index): return
	current_path_index = previous_path_index
	
	constrict_camera(current_path_index)

func constrict_camera(index : int) -> void:
	var current_path : Path2D = level_path_list[index]
	
	var start_point : Vector2 = current_path.to_global(current_path.curve.get_point_position(0))
	var end_point : Vector2 = current_path.to_global(current_path.curve.get_point_position(1))
	
	var start_point_distance : float = (start_point - player.global_position).length()
	var end_point_distance : float = (end_point - player.global_position).length()
	
	current_end_point = end_point
	
	transition_from_position = start_point
	transition_to_position = end_point
	transition_direction_vector = (transition_to_position - transition_from_position).normalized()
	
	current_path_vector = (end_point - start_point).normalized()
	if (current_path_vector.x != 0):
		if (current_path_vector.x > 0):
			camera.limit_left = start_point.x - 160
			camera.limit_right = end_point.x + 160
		else:
			camera.limit_left = end_point.x - 160
			camera.limit_right = start_point.x + 160
			
		camera.limit_top = end_point.y - 90
		camera.limit_bottom = end_point.y + 90
		current_camera_direction = CameraDirection.Horizontal
	elif (current_path_vector.y != 0):
		if (current_path_vector.y < 0):
			camera.limit_bottom = start_point.y + 90
			camera.limit_top = end_point.y - 90
		else:
			camera.limit_top = start_point.y - 90
			camera.limit_bottom = end_point.y + 90
		
		camera.limit_left = end_point.x - 160
		camera.limit_right = end_point.x + 160
		current_camera_direction = CameraDirection.Vertical
	else:
		camera.limit_bottom = start_point.y + 90
		camera.limit_top = end_point.y - 90
		camera.limit_left = end_point.x - 160
		camera.limit_right = end_point.x + 160
		current_camera_direction = CameraDirection.None

enum CameraDirection { None, Horizontal, Vertical }
