extends StaticBody2D
class_name Door

@onready var camera_end_pivot : Node2D = $CameraPivot
@onready var animation_player = $AnimationPlayer

@export var target_camera_path_index : int 

func _on_area_entered(area: Area2D) -> void:
	SignalBus.on_door_transition_start.emit(self, target_camera_path_index)

func open(opening : bool) -> void:
	if (opening): animation_player.play("open")
	else: animation_player.play("close")
