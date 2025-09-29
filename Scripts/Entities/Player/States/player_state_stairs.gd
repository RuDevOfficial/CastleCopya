extends State
class_name PlayerStairs

@export var controller : CharacterBody2D
@export var area : Area2D
@export var animation_tree : AnimationTree
@export var sprite_list : Array[Sprite2D]

var follow_path : PathFollow2D

var start_stair_vector : Vector2

var begin_at_start : bool = true
var stairs_go_up : bool = false
var stair_vector : Vector2
var last_axis : Vector2

var attacking_on_stairs : bool = false

func _ready() -> void:
	
	SignalBus.on_warp_entered.connect(overwrite_path)

func Enter():
	player_resource.IsOnStairs = true
	
	var area_entered = area.get_overlapping_areas().get(0)
	
	var path_node : Path2D = area_entered.owner.get_node("Path")
	follow_path = path_node.get_child(0)
	
	var axis : Vector2 = Vector2.DOWN * Input.get_axis("enter_stairs_up", "enter_stairs_down")
	
		# CHECK THE FIRST 2 POINTS
	var point_0 : Vector2 = path_node.curve.get_point_position(0)
	var point_1 : Vector2 = path_node.curve.get_point_position(1)
		
	# DOT PRODUCT POSITIVE MEANS IT IS GOING IN THE RIGHT DIRECTION
	# IF NOT GO BACK TO THE NORMAL STATE
	start_stair_vector = (point_1 - point_0).normalized()
	
	if (area_entered.name == "Start"):
		# CHECK THE FIRST 2 POINTS
		
		# DOT PRODUCT POSITIVE MEANS IT IS GOING IN THE RIGHT DIRECTION
		# IF NOT GO BACK TO THE NORMAL STATE
		stair_vector = (point_1 - point_0).normalized()
		stairs_go_up = start_stair_vector.y < 0
		
		if (stair_vector.dot(axis) < 0): 
			Exiting.emit(self, "Normal")
			return
			
		# CONTINUE IF DOT PRODUCT > 0
		follow_path.progress_ratio = 0.01
		controller.global_position = follow_path.global_position
		
		begin_at_start = true
	else:
		var total_points = path_node.curve.point_count
		
		# CHECK THE FIRST 2 POINTS
		point_0 = path_node.curve.get_point_position(total_points - 1)
		point_1 = path_node.curve.get_point_position(total_points - 2)
		
		# DOT PRODUCT POSITIVE MEANS IT IS GOING IN THE RIGHT DIRECTION
		# IF NOT GO BACK TO THE NORMAL STATE
		var vector = (point_1 - point_0).normalized()
		stairs_go_up = vector.y < 0
		if (vector.dot(axis) < 0): 
			Exiting.emit(self, "Normal")
			return
		
		# CONTINUE IF DOT PRODUCT > 0
		follow_path.progress_ratio = 0.99
		controller.global_position = follow_path.global_position
		
		begin_at_start = false
		
		
	controller.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	animation_tree.set("parameters/conditions/not_on_stairs", false)
	animation_tree.set("parameters/conditions/on_stairs", true)

func Exit():
	player_resource.IsOnStairs = false
	
	animation_tree.set("parameters/conditions/not_on_stairs", true)
	animation_tree.set("parameters/conditions/on_stairs", false)

func Update(delta: float):
	
	if (Input.is_action_just_pressed("attack") && attacking_on_stairs == false):
		attacking_on_stairs = true
		var timer : SceneTreeTimer = get_tree().create_timer(player_resource.AttackTime)
		timer.timeout.connect(func(): 
			attacking_on_stairs = false
			animation_tree.set("parameters/conditions/attacking_stair", false)
			animation_tree.set("parameters/conditions/not_attacking_stair", true))
		
		# DO LOGIC ANIMATION HERE
		animation_tree.set("parameters/conditions/attacking_stair", true)
		animation_tree.set("parameters/conditions/not_attacking_stair", false)
		
		var left_input = PlayerInput.get_last_input().x
		if (start_stair_vector.x > 0 && start_stair_vector.y < 0): 
			animation_tree.set("parameters/AttackStair/blend_position", Vector2(left_input, 1))
		elif (start_stair_vector.x > 0 && start_stair_vector.y > 0):
			animation_tree.set("parameters/AttackStair/blend_position", Vector2(left_input, -1))
	
	if (attacking_on_stairs == true): return
	
	if (PlayerInput.is_non_zero()):
			if (start_stair_vector.x > 0 && start_stair_vector.y < 0): 
				if (PlayerInput.is_inputting_up_right_corner(false)): animation_tree.set("parameters/Stairs/blend_position", Vector2(1, -1))
				else: animation_tree.set("parameters/Stairs/blend_position", Vector2(-1, 1))
			elif (start_stair_vector.x > 0 && start_stair_vector.y > 0):
				if (PlayerInput.is_inputting_down_right_corner(false)): animation_tree.set("parameters/Stairs/blend_position", Vector2(1, 1))
				else: animation_tree.set("parameters/Stairs/blend_position", Vector2(-1, -1))
	else:
		animation_tree.set("parameters/Stairs/blend_position", Vector2(PlayerInput.get_last_input().x, 0))
	
	if (follow_path.progress_ratio == 1 || follow_path.progress_ratio == 0):
		controller.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		player_resource.LastDirection = PlayerInput.get_input().x
		Exiting.emit(self, "Normal")
		return

func Physics_Update(delta: float):
	if (PlayerInput.is_non_zero() == false): return
	if (attacking_on_stairs == true): return
	
	var downwards_delta: float = delta * player_resource.stair_movement_multiplier
	
	if (start_stair_vector.x > 0 && start_stair_vector.y < 0):
		if (PlayerInput.is_inputting_up_right_corner(false)): follow_path.progress_ratio += delta / 2
		elif (PlayerInput.is_inputting_down_left_corner(false)): follow_path.progress_ratio -= downwards_delta / 2
	elif (start_stair_vector.x > 0 && start_stair_vector.y > 0):
		if (PlayerInput.is_inputting_down_right_corner(false)): follow_path.progress_ratio += downwards_delta / 2
		elif (PlayerInput.is_inputting_up_left_corner(false)): follow_path.progress_ratio -= delta / 2
	elif (start_stair_vector.x < 0 && start_stair_vector.y > 0):
		if (PlayerInput.is_inputting_down_left_corner(false)): follow_path.progress_ratio += downwards_delta / 2
		elif (PlayerInput.is_inputting_up_right_corner(false)): follow_path.progress_ratio -= delta / 2
	else:
		if (PlayerInput.is_inputting_up_left_corner(false)): follow_path.progress_ratio += delta / 2
		elif (PlayerInput.is_inputting_down_right_corner(false)): follow_path.progress_ratio -= downwards_delta / 2
		
	controller.global_position = follow_path.global_position

func overwrite_path(position : Vector2, camera_path_index : int, 
path : Path2D, path_progress : float, is_entrance : bool) -> void:
	if (player_resource.IsOnStairs == false): return
	
	var path_node : Path2D = path
	follow_path = path_node.get_child(0)
	
	var axis : Vector2 = Vector2.DOWN * Input.get_axis("enter_stairs_up", "enter_stairs_down")
	
		# CHECK THE FIRST 2 POINTS
	var point_0 : Vector2 = path_node.curve.get_point_position(0)
	var point_1 : Vector2 = path_node.curve.get_point_position(1)
		
	# DOT PRODUCT POSITIVE MEANS IT IS GOING IN THE RIGHT DIRECTION
	# IF NOT GO BACK TO THE NORMAL STATE
	start_stair_vector = (point_1 - point_0).normalized()
	
	if (is_entrance):
		# CHECK THE FIRST 2 POINTS
		
		# DOT PRODUCT POSITIVE MEANS IT IS GOING IN THE RIGHT DIRECTION
		# IF NOT GO BACK TO THE NORMAL STATE
		stair_vector = (point_1 - point_0).normalized()
		stairs_go_up = start_stair_vector.y < 0
		
		if (stair_vector.dot(axis) < 0): 
			Exiting.emit(self, "Normal")
			return
			
		# CONTINUE IF DOT PRODUCT > 0
		follow_path.progress_ratio = path_progress
		controller.global_position = follow_path.global_position
		
		begin_at_start = true
	else:
		var total_points = path_node.curve.point_count
		
		# CHECK THE FIRST 2 POINTS
		point_0 = path_node.curve.get_point_position(total_points - 1)
		point_1 = path_node.curve.get_point_position(total_points - 2)
		
		# DOT PRODUCT POSITIVE MEANS IT IS GOING IN THE RIGHT DIRECTION
		# IF NOT GO BACK TO THE NORMAL STATE
		var vector = (point_1 - point_0).normalized()
		stairs_go_up = vector.y < 0
		if (vector.dot(axis) < 0): 
			Exiting.emit(self, "Normal")
			return
		
		# CONTINUE IF DOT PRODUCT > 0
		follow_path.progress_ratio = path_progress
		controller.global_position = follow_path.global_position
		
		begin_at_start = false
		
		
	controller.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	animation_tree.set("parameters/conditions/not_on_stairs", false)
	animation_tree.set("parameters/conditions/on_stairs", true)
