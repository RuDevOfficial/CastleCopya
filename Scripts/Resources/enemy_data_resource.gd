extends Resource
class_name EnemyDataResource

@export var starting_health : int
@export var stun_time : float

@export var initial_speed : float = 1.0
@export var initial_contact_damage : int = 1
@export var initial_direction : int

@export var initial_flicker_amount : int = 4

@export var hit_sound_name : String
@export var death_sound_name : String

@export_category("Options")

@export var can_be_stunned : bool = true
@export var disable_contact_on_stun : bool = false
