extends Consumable
class_name Heart

@export var amount : int

func consume_item() -> void:
	SignalBus.on_heart_collected.emit(amount)
