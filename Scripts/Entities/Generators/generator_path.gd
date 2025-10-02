extends Node2D
class_name PathEnemyGenerator
# A type of enemy generator that spawns a new enemy alongside a point
# in the 2D path given

@onready var path_follow : PathFollow2D = $SpawnPath/PathFollow2D
@onready var generation_timer : Timer = $Timer

@export var generation_wait_time : float = 1.0

@export var generating_enemies : bool = true
@export var enemy_scene : PackedScene

var parent : Node2D

func _ready() -> void:
	parent = get_parent().get_parent().get_node("Enemies")
	
	generation_timer.wait_time = generation_wait_time
	generation_timer.timeout.connect(generate_new_enemy)

func generate_new_enemy() -> void:
	if (generating_enemies == false): return
	
	# Getting a random point from the path
	path_follow.progress_ratio = randf()
	
	var new_enemy : Enemy = enemy_scene.instantiate()
	new_enemy.global_position = path_follow.global_position
	
	new_enemy.initialize()
	parent.add_child(new_enemy)

func _on_screen_exited() -> void:
	generating_enemies = false

func _on_screen_entered() -> void:
	generating_enemies = true
