extends SubweaponModifierResource
class_name SM_Throw_FlipDirection
# Flips the direction based on the linear velocity when thrown

func Modify(new_reference : Subweapon):
	super.Modify(new_reference)

func OnThrown(throw_direction : Vector2) -> void:
	var rigidbody2D : RigidBody2D =	subweapon_reference.Subweapon_Resource.Agent
	if (rigidbody2D.linear_velocity.x > 0): pass
	else: rigidbody2D.get_node("Sprite").flip_h = true
