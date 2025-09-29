extends Resource
class_name PlayerResource

var Agent : Node2D

# Components
var AnimTree : AnimationTree

# Movement Related
@export_category("Movement")
var CanMove : bool
@export var Speed : float
@export var LastDirection : float = 1
var Velocity : Vector2
var WasCrouched : bool
@export var stair_movement_multiplier : float

# Gravity Related
@export_category("Gravity")
var StartingGravity : float
@export var Gravity : float
@export var FallingCap : float
@export var FallingMultiplier : float

# Jumping Related
@export_category("Jump")
@export var JumpForce : float

# Other
@export_category("Other")
@export var StartingHealth : int
@export var DeadTime : float
@export var KnockbackVector : Vector2
@export var KnockbackForce : float
var HealthComponent : Health
var IsOnStairs : bool

# Subweapons
@export_category("Attack")
@export var AttackTime : float
@export var CurrentSubweapon : SubweaponDataResource

func SetDefaultValues(agent : Node2D) -> void:
	StartingGravity = Gravity
	Agent = agent
	HealthComponent = agent.get_node("Components/Health")
	AnimTree = agent.get_node("Animation/AnimationTree")
