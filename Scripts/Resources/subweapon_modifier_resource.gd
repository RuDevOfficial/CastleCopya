extends Resource
class_name SubweaponModifierResource
# Base class for a subweapon modifier resource
# Each resource can target one or many (like when thrown and on contact)
# (make a new one by creating a new script and inheriting this, then just overwrite the
# method that you need and create an instance of the resource to then attach on the subweapon)

var subweapon_reference : Subweapon

func Modify(new_reference : Subweapon):
	subweapon_reference = new_reference

func Update(delta: float) -> void:
	pass

func PhysicsUpdate(delta: float) -> void:
	pass

func OnContact(area : Area2D) -> void:
	pass

func OnThrown(throw_direction : Vector2) -> void:
	pass

func OnLifetimeReached() -> void:
	pass
