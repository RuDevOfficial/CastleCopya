extends Node

var already_hit : bool = false

func _on_whip_hitbox_area_entered(area: Area2D) -> void:
	if (area.owner is not Enemy || already_hit): return
	already_hit = true
	
	var enemy : Enemy = area.owner
	SignalBus.on_enemy_hit.emit(enemy)
	
	already_hit = false
