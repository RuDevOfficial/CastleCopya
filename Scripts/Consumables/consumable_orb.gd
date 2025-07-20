extends Consumable
class_name OrbConsumable

@export var appear_sound : String

func consume_item() -> void:
	MusManager.stop_music(true)
	SfxManager.do_one_shot("Stage_Clear")
	SignalBus.on_clear_level.emit()

func appear() -> void:
	SfxManager.do_one_shot(appear_sound)
	
	self.gravity_scale = 0
	self.freeze = true

func drop() -> void:
	self.gravity_scale = 1
	self.freeze = false
