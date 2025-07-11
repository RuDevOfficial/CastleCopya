extends Node

@export var camera : Camera2D
@export var player : PlayerCharacter

@onready var dummy_player = $DummyPlayer
@onready var dummy_player_animator = $DummyPlayer/AnimationPlayer

var is_transitioning : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dummy_player.visible = false
	
	SignalBus.on_door_transition_start.connect(begin_door_transition)

func begin_door_transition(door : Door) -> void:
	if (is_transitioning): return
	is_transitioning = true
	
	player.freeze_player(null)
	
	player.visible = false
	dummy_player.global_position = player.global_position
	dummy_player.visible = true
	
	# ========= STEP 1 ============
	
	await get_tree().create_timer(0.5).timeout #DOOR OPENS
	door.open(true)
	
	# ========= STEP 2 ============
	
	dummy_player_animator.play("run")
	
	var tween_player = get_tree().create_tween()  #DUMMY MOVES TO THE RIGHT
	tween_player.tween_property(dummy_player, "global_position", Vector2(dummy_player.global_position.x + 64, dummy_player.global_position.y), 1)
	tween_player.tween_callback(
		func():
			door.open(false)
			dummy_player_animator.play("idle"))
	
	await tween_player.finished
	
	# ========= STEP 3 ============
	
	SignalBus.on_door_transition_camera_transition_start.emit()
	await SignalBus.on_door_transition_finish
	
	player.global_position = dummy_player.global_position
	player.visible = true
	player.activate_player()
	dummy_player.visible = false
	is_transitioning = false
	#SignalBus.on_door_transition_finish.emit()
