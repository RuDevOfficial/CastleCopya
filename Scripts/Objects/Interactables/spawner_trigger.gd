extends Area2D
# Simple 2D area that can turn on, change the spawning enemy or turn off the generator.

@export var activate_spawner : bool
@export var enemy_per_seconds : float
@export var enemy_name : String

func _on_area_entered(area: Area2D) -> void:
	if (activate_spawner == true): 
		SpawnerManager.current_enemy_name = enemy_name
		SpawnerManager.activate_spawner(enemy_per_seconds)
	else: SpawnerManager.deactivate_spawner()
