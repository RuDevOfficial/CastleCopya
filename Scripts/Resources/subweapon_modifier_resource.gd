extends Resource
class_name SubweaponModifierResource

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
