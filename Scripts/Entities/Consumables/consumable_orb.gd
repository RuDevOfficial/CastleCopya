extends Consumable
class_name OrbConsumable

@export var appear_sound : String

func consume_item() -> void:
	AudioManager.stop_music(true)
	AudioManager.do_one_shot("Stage_Clear")
	SignalBus.on_clear_level.emit()

func appear() -> void:
	AudioManager.do_one_shot(appear_sound)
	
	self.gravity_scale = 0
	self.freeze = true

func drop() -> void:
	self.gravity_scale = 1
	self.freeze = false
