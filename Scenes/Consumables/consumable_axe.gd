extends Consumable
class_name SubweaponConsumable

@export var subweapon_data_resource : SubweaponDataResource

func consume_item() -> void:
	SignalBus.on_subweapon_collected.emit(subweapon_data_resource)
