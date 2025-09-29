extends Node2D
class_name Consumable

@export var sound_key : String

func _on_player_enter_area(area : Area2D) -> void:
	generate_sound_effect()
	consume_item()
	queue_free()

func consume_item() -> void:
	pass

func generate_sound_effect() -> void:
	if (sound_key == null): return
	
	AudioManager.do_one_shot(sound_key)
