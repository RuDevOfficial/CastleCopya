extends PlayerHealthUIManager

var previous_enemy : Enemy = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_enemy_hit.connect(update_bar_enemy_hit)
	SignalBus.on_enemy_death.connect(death_override_all_bars)
	SignalBus.on_level_fade_completed.connect(func(): previous_enemy = null)

func update_bar_enemy_hit(enemy : Enemy) -> void:
	if (enemy != previous_enemy): 
		previous_enemy = enemy
		
		for child in horizontal_container.get_children():
			if (child is Label): continue
			child.queue_free()
		
		bar_list.clear()
			
		add_max_bars(previous_enemy.starting_health)
		update_bar_state(previous_enemy.starting_health, previous_enemy.health_component.get_current())
	else:
		update_bar_state(previous_enemy.starting_health, previous_enemy.health_component.get_current())
