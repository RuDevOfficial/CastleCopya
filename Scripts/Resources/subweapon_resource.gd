extends Resource
class_name SubweaponResource

var Agent : Node2D

@export_category("General")
@export var Lifetime : float
@export var Damage : float

# Movement Related
@export_category("Movement")
@export var Speed : float
var Velocity : Vector2
var Direction : Vector2

@export_category("Other")
@export var SoundKey : String

func Initialize(agent : Node2D) -> void:
	Agent = agent
