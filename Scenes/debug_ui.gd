extends Control

@export var mute_music : bool = true

func _ready() -> void:
	if (mute_music == true): MusManager.overwrite_volume(0)

func _on_win_pressed() -> void:
	MusManager.stop_music(true)
	SfxManager.do_one_shot("Stage_Clear")
	SignalBus.on_clear_level.emit()

func _on_save_pressed() -> void:
	print("fuck")

func _on_toggle_music_pressed() -> void:
	if (mute_music == true): MusManager.overwrite_volume(1)
	else: MusManager.overwrite_volume(0)
	
	mute_music = !mute_music
