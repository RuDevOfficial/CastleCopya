extends SubweaponModifierResource
class_name SM_Lifetime_Destroy

func Modify(new_reference : Subweapon):
	super.Modify(new_reference)

func OnLifetimeReached() -> void:
	subweapon_reference.queue_free()
