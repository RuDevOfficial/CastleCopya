extends Control

@onready var bat : Node2D = $Bat
@export var point_list_parent : Control
var control_list : Array[Control]

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	for node in point_list_parent.get_children():
		var control : Control = node
		control_list.push_back(control)
	
	visible = false
	
	connect_signals()

func connect_signals() -> void:
	GStateManager.on_enter_intermission.connect(enable_ui)
	GStateManager.on_exit_intermission.connect(disable_ui)

func enable_ui() -> void:
	visible = true
	
	load_intermission(StageManager.current_level_index)

func disable_ui() -> void:
	visible = false

func load_intermission(number : int) -> void:
	bat.global_position = control_list[number].global_position
	animation_player.play("transition")

# THIS METHOD IS CALLED ON THE ANIMATION PLAYER (END OF ANIM)
func end_intermission() -> void:
	SignalBus.on_finish_intermission.emit()
