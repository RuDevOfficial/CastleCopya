extends RigidBody2D
class_name Enemy

@onready var behavior_player : BTPlayer = $BTPlayer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var health_component : Health = $Components/Health

@onready var hurtbox : Hurtbox = $Contact/Hurtbox
@onready var hitbox : Hitbox = $Contact/Hitbox

@onready var sprite : Sprite2D = $Sprite

@onready var death_sound : FmodEventEmitter2D = $Sounds/DeathEmitter

var target_player : Node2D

var starting_position : Vector2
var starting_direction : int
var starting_health : int

func _ready() -> void:
	target_player = get_tree().get_first_node_in_group("player")
	
	starting_position = global_position
	starting_direction = behavior_player.blackboard.get_var("direction")
	starting_health = health_component.get_current()
	
	EnemyManager.add_enemy_to_list(self)

func reset_values():
	hitbox.monitoring = true
	hurtbox.monitorable = true
	
	if (target_player.global_position.x > global_position.x): 
		behavior_player.blackboard.set_var("direction", 1)
		sprite.flip_h = true
	else:
		behavior_player.blackboard.set_var("direction", -1)
		sprite.flip_h = false
	
	behavior_player.restart()
	behavior_player.active = true
	
	sprite.visible = true

func get_disabled():
	
	death_sound.play_one_shot()
	
	global_position = starting_position
	health_component.set_health(starting_health)
	
	hitbox.monitoring = false
	hurtbox.monitorable = false
	
	behavior_player.blackboard.set_var("direction", starting_direction)
	behavior_player.active = false
	
	sprite.visible = false
