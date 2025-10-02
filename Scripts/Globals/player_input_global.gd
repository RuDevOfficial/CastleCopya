extends Node
# A script used to get a more precise player input.

var left_input : int
var right_input : int
# ⬇️
var horizontal_input : int 

var down_input : int
var up_input : int
# ⬇️
var vertical_input : int

# The most recent player input
var player_input : Vector2

# The most recent player input that was different from the previous
var last_different_player_input : Vector2

var last_corner_input : CornerInput

func _process(delta: float) -> void:
	left_input = Input.is_action_pressed("move_left")
	right_input = Input.is_action_pressed("move_right")
	down_input = Input.is_action_pressed("enter_stairs_down")
	up_input = Input.is_action_pressed("enter_stairs_up")
	
	horizontal_input = -left_input + right_input
	vertical_input = -up_input + down_input
	
	player_input = Vector2(horizontal_input, vertical_input)
	
	# GETS THE LAST INPUT THAT WASN'T ZERO
	if (player_input != Vector2.ZERO): 
		if (player_input != last_different_player_input):
			last_different_player_input = player_input
	
	if (is_inputting_down_left_corner(true)): last_corner_input = CornerInput.DownLeft
	elif (is_inputting_down_right_corner(true)): last_corner_input = CornerInput.DownRight
	elif (is_inputting_up_left_corner(true)): last_corner_input = CornerInput.UpLeft
	elif (is_inputting_up_right_corner(true)): last_corner_input = CornerInput.UpRight

func is_non_zero() -> bool:
	return player_input != Vector2.ZERO

func is_inputting_up_right_corner(using_last_input : bool) -> bool:
	if (using_last_input):
		return last_different_player_input.x == 1 || last_different_player_input.y == -1
	else:
		return player_input.x == 1 || player_input.y == -1

func is_inputting_down_right_corner(using_last_input : bool) -> bool:
	if (using_last_input):
		return last_different_player_input.x == 1 || last_different_player_input.y == 1
	else:
		return player_input.x == 1 || player_input.y == 1

func is_inputting_down_left_corner(using_last_input : bool) -> bool:
	if (using_last_input):
		return last_different_player_input.x == -1 || last_different_player_input.y == 1
	else:
		return player_input.x == -1 || player_input.y == 1

func is_inputting_up_left_corner(using_last_input : bool) -> bool:
	if (using_last_input):
		return last_different_player_input.x == -1 || last_different_player_input.y == -1
	else:
		return player_input.x == -1 || player_input.y == -1

func get_horizontal_input() -> int: return horizontal_input
func get_vertical_input() -> int: return vertical_input
func get_input() -> Vector2: return player_input
func get_last_input() -> Vector2: return last_different_player_input
func get_last_corner_input_enum() -> CornerInput: return last_corner_input

enum CornerInput {UpRight, DownRight, DownLeft, UpLeft}
