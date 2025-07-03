extends Node
class_name EntityManager

var enemy_list : Array[Enemy]

func _ready() -> void: 
	SignalBus.on_begin_transition.connect(disable_all_entities)
	SignalBus.on_end_transition.connect(reset_all_entities)

func add_enemy_to_list(enemy : Enemy): enemy_list.push_back(enemy)
func remove_enemy_from_list(enemy : Enemy): enemy_list.erase(enemy)

func disable_all_entities(): 
	for enemy in enemy_list: enemy.get_disabled()

func reset_all_entities(): 
	for enemy in enemy_list: enemy.reset_values()
