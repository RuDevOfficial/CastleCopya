extends Node

var current_enemy_name : String
var timer : Timer
var camera_player_distance_threshold : float = 50.0

@export var enemy_list : Dictionary[String, PackedScene]

var player : PlayerCharacter

func _init() -> void:
	timer = Timer.new()
	timer.one_shot = false
	timer.autostart = false
	
	timer.timeout.connect(spawn_current_enemy_at_edge_screen)
	
	add_child(timer)

func _ready() -> void:
	dir_contents("res://Scenes/Entities/Enemies/")
	player = get_tree().get_first_node_in_group("player")

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path = path.path_join(file_name)
					var enemy_name = file_name.split(".")[0]
					
					enemy_list.get_or_add(enemy_name, load(full_path))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func activate_spawner(time : float) -> void:
	if (timer.is_stopped() == false): return
	
	timer.start(time)
	spawn_current_enemy_at_edge_screen()

func deactivate_spawner() -> void: timer.stop()

func swap_spawned_enemy(new_name : String) -> void: current_enemy_name = new_name
func is_spawner_active() -> bool: return timer.is_stopped() == false

func spawn_current_enemy_at_edge_screen():
	if (enemy_list.has(current_enemy_name)):
		var level = get_tree().get_first_node_in_group("level")
		
		var camera : Camera2D = get_viewport().get_camera_2d()
		var camera_size : float = camera.get_viewport_rect().size.x * camera.zoom.x
		
		var spawn_direction : int
		var camera_player_distance : float = player.global_position.x - camera.get_screen_center_position().x
		
		# Checks if the player is further from the camera before spawn, because if it is
		# that means that the camera is static and the player is on the corner of the level
		# If not that means the camera is following the player and we have to take his direction
		# instead as a reference
		if (abs(camera_player_distance) >= camera_player_distance_threshold):
			if (camera_player_distance >= 0): spawn_direction = -1
			else: spawn_direction = 1
		else: spawn_direction = player.player_resource.LastDirection
		print(camera_player_distance)
		
		var new_enemy : Enemy = enemy_list.get(current_enemy_name).instantiate()
		new_enemy.global_position.y = player.global_position.y
		new_enemy.global_position.x = camera.get_screen_center_position().x + (8 * spawn_direction) + (get_window().content_scale_size.x/8 * spawn_direction)
		
		new_enemy.data.initial_direction = spawn_direction * -1
		new_enemy.remain_active(true)
		
		level.get_node("Entities/Enemies").add_child(new_enemy)
