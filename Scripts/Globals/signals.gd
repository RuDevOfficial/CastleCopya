extends Node

signal on_level_loaded

signal on_heart_collected
signal on_subweapon_collected

signal on_level_fade_completed
signal on_level_finish_load

#PLAYER RELATED
signal on_player_take_damage
signal on_player_death

#ENEMY RELATED
signal on_enemy_hit
signal on_enemy_death

#DOOR TRANSITION RELATED
signal on_door_transition_start
signal on_door_transition_camera_transition_start
signal on_door_transition_finish # UNUSED

#NEW TRANSITION SIGNALS
signal on_begin_transition
signal on_middle_transition
signal on_end_transition

#LEVEL GENERATION RELATED
signal on_level_generated
