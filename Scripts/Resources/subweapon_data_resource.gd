extends Resource
class_name SubweaponDataResource

@export_category("Graphic")
@export var Icon : Texture2D

@export_category("General")
@export var ThrowDelay : float = 0.0
@export var Cooldown : float = 0.5
@export var Cost : int
@export var vertical_ground_throw_offset : float
@export var vertical_air_throw_offset : float
@export var Scene : PackedScene

@export_category("Player")
@export var animation_speed : float = 1.0
