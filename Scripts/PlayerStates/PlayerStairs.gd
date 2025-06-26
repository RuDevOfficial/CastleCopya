extends State
class_name PlayerStairs

@export var controller : CharacterBody2D
@export var area : Area2D

var follow_path : PathFollow2D

var begin_at_start : bool = true
var stairs_go_up : bool = false

func Enter():
	for area_overlapped in area.get_overlapping_areas():
		
		var path_node : Path2D = area_overlapped.owner.get_node("Path")
		follow_path = path_node.get_child(0)
		
		var axis : Vector2 = Vector2.DOWN * Input.get_axis("enter_stairs_up", "enter_stairs_down")
		
		if (area_overlapped.name == "Start"):
			# CHECK THE FIRST 2 POINTS
			var point_0 : Vector2 = path_node.curve.get_point_position(0)
			var point_1 : Vector2 = path_node.curve.get_point_position(1)
			
			# DOT PRODUCT POSITIVE MEANS IT IS GOING IN THE RIGHT DIRECTION
			# IF NOT GO BACK TO THE NORMAL STATE
			var vector : Vector2 = (point_1 - point_0).normalized()
			stairs_go_up = vector.y < 0
			
			if (vector.dot(axis) < 0): 
				Exiting.emit(self, "Normal")
				return
			
			# CONTINUE IF DOT PRODUCT > 0
			follow_path.progress_ratio = 0.01
			controller.global_position = follow_path.global_position
			
			begin_at_start = true
		else:
			var total_points = path_node.curve.point_count
			
			# CHECK THE FIRST 2 POINTS
			var point_0 : Vector2 = path_node.curve.get_point_position(total_points - 1)
			var point_1 : Vector2 = path_node.curve.get_point_position(total_points - 2)
			
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

func Exit():
	pass

func Update(_delta: float):
	if (follow_path.progress_ratio == 1 || follow_path.progress_ratio == 0):
		controller.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		Exiting.emit(self, "Normal")
		return

func Physics_Update(delta: float):
	if (Input.is_action_pressed("enter_stairs_up")):
		if (begin_at_start && stairs_go_up):
			follow_path.progress_ratio += delta / 2
			
		elif (begin_at_start == false && stairs_go_up == false):
			follow_path.progress_ratio += delta / 2
		
		elif (begin_at_start == false && stairs_go_up):
			follow_path.progress_ratio -= delta / 2
		
		elif (begin_at_start && stairs_go_up == false):
			follow_path.progress_ratio -= delta / 2
		
		controller.global_position = follow_path.global_position
	
	elif (Input.is_action_pressed("enter_stairs_down")):
		if (begin_at_start && stairs_go_up):
			follow_path.progress_ratio -= delta / 2
		
		elif (begin_at_start == false && stairs_go_up == false):
			follow_path.progress_ratio -= delta / 2
		
		elif (begin_at_start && stairs_go_up == false):
			follow_path.progress_ratio += delta / 2
		
		elif (begin_at_start == false && stairs_go_up):
			follow_path.progress_ratio += delta / 2
		
		controller.global_position = follow_path.global_position
