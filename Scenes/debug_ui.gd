extends Control

func _on_win_pressed() -> void:
	MusManager.stop_music(true)
	SfxManager.do_one_shot("Stage_Clear")
	SignalBus.on_clear_level.emit()
