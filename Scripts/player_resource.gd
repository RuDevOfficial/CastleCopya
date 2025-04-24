extends Resource
class_name PlayerResource

var Velocity : Vector2

# Movement Related
@export_category("Movement")
var CanMove : bool
@export var Speed : float
var LastDirection : float

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

func SetDefaultValues() -> void:
	StartingGravity = Gravity
