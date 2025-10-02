extends SubweaponModifierResource
class_name SM_Throw_AddOffset
# Adds a positional offset when thrown

@export var offset : Vector2

func OnThrown(throw_direction : Vector2) -> void:
	subweapon_reference.global_position += Vector2(offset.x * throw_direction.x, offset.y)
