extends Control

@export_category("Audio")
@export var mute_music : bool = true

@export_category("Player")
@export var player_character : PlayerCharacter

@export var speed_up_character : bool = false
@export var player_speed_multiplier : float = 1.0

@export var increase_jump_character : bool = false
@export var increase_jump_multiplier : float = 3.0

@export_category("Camera")
@export var camera : Camera2D
@export var zoom_factor : float = 4
var starting_zoom : Vector2
var camera_zoomed : bool = false

@export_category("Instant Boss")
@export var camera_manager : Node

func _ready() -> void:
	if (mute_music == true): MusManager.overwrite_volume(0)
	starting_zoom = camera.zoom

func _on_win_pressed() -> void:
	MusManager.stop_music(true)
	SfxManager.do_one_shot("Stage_Clear")
	SignalBus.on_clear_level.emit()

func _on_save_pressed() -> void:
	print("saved") # TODO ACTUALLY SAVE

func _on_toggle_music_pressed() -> void:
	if (mute_music == true): MusManager.overwrite_volume(1)
	else: MusManager.overwrite_volume(0)
	
	mute_music = !mute_music

func _on_super_speed_pressed() -> void:
	if (speed_up_character == false): 
		player_character._playerResource.Speed *= player_speed_multiplier
	else:
		player_character._playerResource.Speed /= player_speed_multiplier
	
	speed_up_character = !speed_up_character

func _on_toggle_camera_zoom_pressed() -> void:
	if (camera_zoomed == false): camera.zoom = Vector2.ONE * zoom_factor
	else: camera.zoom = starting_zoom
	
	camera_zoomed = !camera_zoomed

func _on_go_to_boss_pressed() -> void:
	SignalBus.on_debug_teleport_to_boss.emit()

func _on_super_jump_pressed() -> void:
	if (increase_jump_character == false): 
		player_character._playerResource.JumpForce *= increase_jump_multiplier
	else:
		player_character._playerResource.JumpForce /= increase_jump_multiplier
	
	increase_jump_character = !increase_jump_character
