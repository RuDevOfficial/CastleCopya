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
@export var DeadTime : float
@export var KnockbackVector : Vector2
@export var KnockbackForce : float
var HealthComponent : Health

# Subweapons
@export_category("Subweapon")
@export var CurrentSubweapon : SubweaponDataResource
@export var SubweaponUses : int = 20
var ThrowDelay : float = 0.0
var SubweaponUsedTrigger : bool

func SetDefaultValues(agent : Node2D) -> void:
	StartingGravity = Gravity
	Agent = agent
	HealthComponent = agent.get_node("Components/Health")
	AnimTree = agent.get_node("Animation/AnimationTree")
