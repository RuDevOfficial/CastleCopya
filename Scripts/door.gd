extends StaticBody2D
class_name Door

@onready var camera_end_pivot = $CameraPivot
@onready var animation_player = $AnimationPlayer

@export var open_sprite : CompressedTexture2D
@export var close_sprite : CompressedTexture2D

func _on_area_entered(area: Area2D) -> void:
	SignalBus.on_door_transition_start.emit(self)

func open(opening : bool) -> void:
	if (opening): animation_player.play("open")
	else: animation_player.play("close")
