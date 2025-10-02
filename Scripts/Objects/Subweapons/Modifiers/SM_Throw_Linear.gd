extends SubweaponModifierResource
class_name SM_Throw_2DLinearX
# Throws the subweapon only in the x axis when thrown

func Modify(new_reference : Subweapon):
	super.Modify(new_reference)

func OnThrown(throw_direction : Vector2) -> void:
	var rigidbody2D : RigidBody2D =	subweapon_reference.Subweapon_Resource.Agent
	var velocity = Vector2(throw_direction.x * subweapon_reference.Subweapon_Resource.Speed, 0)
	rigidbody2D.linear_velocity += velocity
