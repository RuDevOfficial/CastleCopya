extends SubweaponModifierResource
class_name SM_Lifetime_Destroy
# Destroys the subweapon after the lifetime reaches.

func Modify(new_reference : Subweapon):
	super.Modify(new_reference)

func OnLifetimeReached() -> void:
	subweapon_reference.queue_free()
