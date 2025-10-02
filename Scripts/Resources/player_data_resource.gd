extends Resource
class_name PlayerResource
# Resource used to set up all player's values and hold all dynamic information

var Agent : Node2D # Node2D reference of whoever has this resource

# Components
var AnimTree : AnimationTree

# Movement Related
@export_category("Movement")
var CanMove : bool
@export var Speed : float # READ ONLY
@export var LastDirection : float = 1
var Velocity : Vector2
var WasCrouched : bool
@export var stair_movement_multiplier : float

# Gravity Related
@export_category("Gravity")
var StartingGravity : float # READ ONLY, INITIALIZED
@export var Gravity : float
@export var FallingCap : float # READ ONLY
@export var FallingMultiplier : float # READ ONLY

# Jumping Related
@export_category("Jump")
@export var JumpForce : float

# Other
@export_category("Other")
@export var StartingHealth : int # READ ONLY
@export var DeadTime : float # READ ONLY
@export var KnockbackVector : Vector2 # READ ONLY
@export var KnockbackForce : float # READ ONLY
var HealthComponent : Health
var IsOnStairs : bool

# Subweapons
@export_category("Attack")
@export var AttackTime : float # READ ONLY
@export var CurrentSubweapon : SubweaponDataResource

func SetDefaultValues(agent : Node2D) -> void:
	StartingGravity = Gravity
	Agent = agent
	HealthComponent = agent.get_node("Components/Health")
	AnimTree = agent.get_node("Animation/AnimationTree")
