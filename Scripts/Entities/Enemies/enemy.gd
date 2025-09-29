extends RigidBody2D
class_name Enemy

var blackboard : Blackboard

@export_category("Base Parameters")

# This holds are initial values for the enemy
# meant to be READ ONLY
@export var data : EnemyDataResource
@export var respawn_on_view : bool
@export var can_be_stunned : bool
@export var disable_contact_on_stun : bool

# COMPONENTS
@onready var health_component : Health = $Components/Health
@onready var flicker_component : Flicker = $Components/Flicker

@onready var behavior_player : BTPlayer = $BTPlayer

@onready var damage_particle : GPUParticles2D = $Particles/Damage
@onready var death_particle : GPUParticles2D = $Particles/Death

@onready var hurtbox : Hurtbox = $Contact/Hurtbox
@onready var hitbox : Hitbox = $Contact/Hitbox
@onready var sprite : Sprite2D = $Sprite

# Dynamic variables
var original_speed : float
var original_node_path : NodePath

func _ready() -> void:
	original_node_path = $VisibleOnScreenEnabler2D.enable_node_path
	
	health_component.set_health(data.starting_health)
	blackboard = behavior_player.blackboard
	
	on_connect_signals()
	set_default_values()
	
	EnemyManager.add_enemy_to_list(self)
	
	behavior_player.active = true
	behavior_player.restart()
	
	on_ready() # Overwriteable method

func set_default_values() -> void:
	
	# BLACKBOARD VALUES
	blackboard.set_var("speed", data.initial_speed)
	blackboard.set_var("direction", data.initial_direction)
	
	# CONTACT / HEALTH RELATED VALUES
	hitbox.damage = data.initial_contact_damage
	flicker_component._flickerTimes = data.initial_flicker_amount
	flicker_component._flickerTimeIndividual = data.stun_time / (data.initial_flicker_amount * 2)

func _on_health_damaged(amount: float, knockback: Vector2) -> void:
	
	AudioManager.do_one_shot(data.hit_sound_name)
	
	damage_particle.restart()
	SignalBus.on_enemy_hit.emit(self, data.starting_health, health_component.get_current())
	
	on_recieve_damage() # Overwriteable method
	
	if (can_be_stunned == true): stun()

func _on_health_death() -> void:
	AudioManager.do_one_shot(data.death_sound_name)
	
	enable_entity(false)
	
	death_particle.restart()
	SignalBus.on_enemy_death.emit()
	
	on_death() # Overwriteable method

func enable_entity(do_enable : bool) -> void:
	hitbox.monitoring = do_enable
	hurtbox.monitorable = do_enable
	sprite.visible = do_enable
	behavior_player.active = do_enable
	
	if (do_enable == true): 
		behavior_player.restart()

func stun() -> void:
	original_speed = blackboard.get_var("speed")
	blackboard.set_var("speed", 0)
	if (disable_contact_on_stun == true): hitbox.monitoring = false
	
	await get_tree().create_timer(data.stun_time).timeout
	
	blackboard.set_var("speed", original_speed)
	if (disable_contact_on_stun == true): hitbox.monitoring = true

func remain_active(active : bool) -> void:
	if (active): $VisibleOnScreenEnabler2D.enable_node_path = original_node_path
	else: $VisibleOnScreenEnabler2D.enable_node_path = ""

# "VIRTUAL" METHODS to OVERRIDE
func initialize() -> void: pass
func on_ready() -> void: pass
func on_recieve_damage() -> void: pass
func on_death() -> void: pass
func on_connect_signals() -> void: pass
