extends SubweaponModifierResource
class_name SM_Throw_2DVector
@export var vector : Vector2
@export var force : float

func Modify(new_reference : Subweapon):
	super.Modify(new_reference)

func OnThrown(throw_direction : Vector2) -> void:
	var rigidbody2D : RigidBody2D =	subweapon_reference.Subweapon_Resource.Agent
	var velocity = Vector2(vector.x * throw_direction.x, -1).normalized()
	velocity *= force
	rigidbody2D.linear_velocity = velocity
