extends Control
# Class that enables or disables gameplay UI

@onready var bounds_rect : Control = $ColorRect

@export var target_control : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	disable_ui()

func connect_signals() -> void:
	GStateManager.on_enter_gameplay.connect(enable_ui)
	GStateManager.on_exit_gameplay.connect(disable_ui)

func enable_ui() -> void:
	visible = true

func disable_ui() -> void:
	visible = false

func snap_to_location(index : int) -> void:
	var child : Control = get_child(index)
	target_control.position = child.position

enum GameplayUILocation {Top, Bottom}

func _on_camera_top_area_entered(area: Area2D) -> void:
	snap_to_location(1)

func _on_bottom_area_entered(area: Area2D) -> void:
	snap_to_location(0)
