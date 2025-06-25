extends Node2D
class_name Consumable

func _on_player_enter_area(area : Area2D) -> void:
	consume_item()
	queue_free()

func consume_item() -> void:
	pass
