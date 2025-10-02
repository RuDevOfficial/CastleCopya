extends Node
class_name EntityManager
# Manages the disabling and reseting of all entities, used to mimic how an entity would "respawn"
# after leaving the camera view. Any enemy that was generated is removed from the list and destroyed.

var enemy_list : Array[Enemy]

func _ready() -> void: 
	SignalBus.on_middle_transition.connect(disable_all_entities)
	SignalBus.on_end_transition.connect(reset_all_entities)

func add_enemy_to_list(enemy : Enemy): enemy_list.push_back(enemy)
func remove_enemy_from_list(enemy : Enemy): enemy_list.erase(enemy)

func disable_all_entities(is_player_respawning): 
	if (is_player_respawning == false): return
	
	# First pass with just disabling ALL entities
	for enemy in enemy_list:
		enemy.enable_entity(false)
	
	# Second pass, destroying all generated enemies
	# Inverted for loops is the best practice when removing entries.
	for index in range(enemy_list.size() - 1, -1, -1):
		var enemy = enemy_list[index]
		if (enemy.was_generated): 
			enemy_list.remove_at(index)
			enemy.queue_free()

func reset_all_entities(is_player_respawning): 
	if (is_player_respawning == false): return
	
	for enemy in enemy_list: enemy.enable_entity(true)
