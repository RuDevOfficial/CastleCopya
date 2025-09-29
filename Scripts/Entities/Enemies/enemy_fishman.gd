extends Enemy
class_name EnemyFishman

@export var packed_bullet_scene : PackedScene
@export var vector_offset : Vector2
@export var splash_particle_scene : PackedScene

var bullet_instance : Node2D
var returned_to_water : bool = false

var start_y_level : float
var behavior_tree : BehaviorTree

func initialize() -> void:
	start_y_level = global_position.y

func on_ready() -> void:
	
	behavior_tree = $BTPlayer.behavior_tree
	
	bullet_instance = packed_bullet_scene.instantiate()
	bullet_instance.global_position = global_position
	
	await get_tree().process_frame
	get_parent().add_child(bullet_instance)

# if the enemy base class has a _process method and theres
# stuff in it this will overwrite it
func _process(delta: float) -> void:
	if (blackboard.get_var("direction") == 1): sprite.flip_h = true
	else: sprite.flip_h = true
	
	if (global_position.y > start_y_level):
		spawn_particle()
		queue_free()

func spawn_particle() -> void:
	var particle = splash_particle_scene.instantiate()
	particle.global_position = global_position
	get_parent().add_child(particle)

func try_shoot() -> void:
	if (bullet_instance.disabled == true):
		shoot()

func shoot() -> void:
	var direction : float = blackboard.get_var("direction")
	bullet_instance.set_values(direction)
	
	bullet_instance.global_position = global_position + vector_offset
	bullet_instance.do_enable(true)
