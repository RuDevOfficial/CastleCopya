extends Node2D

@export var camera_path_index : int
@export var snap_path_progress : float
@export var reference_stair: Node2D
@export var is_entrance : bool

var warp_position : Vector2
var reference_stair_path : Path2D

func _ready() -> void:
	warp_position = $Point.global_position
	reference_stair_path = reference_stair.get_node("Path")

func _on_area_entered(area: Area2D) -> void:
	SignalBus.on_warp_entered.emit(warp_position, camera_path_index, reference_stair_path, snap_path_progress, is_entrance)
