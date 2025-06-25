extends Node2D
class_name Consumable

@onready var collect_sound : FmodEventEmitter2D = $CollectSound

func _on_player_enter_area(area : Area2D) -> void:
	generate_sound_effect()
	consume_item()
	queue_free()

func consume_item() -> void:
	pass

func generate_sound_effect() -> void:
	if (collect_sound == null): return
	
	collect_sound.play_one_shot()
