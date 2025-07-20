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
signal on_boss_death

#DOOR TRANSITION RELATED
signal on_door_transition_start
signal on_door_transition_camera_transition_start
signal on_door_transition_finish # UNUSED

#WARP RELATED
signal on_warp_entered(player_position : Vector2, camera_path_index : int, path : Path2D, path_progress : float, is_entrance : bool)

#CAMERA RELATED
signal on_trigger_new_path(path : CameraPath)

#NEW TRANSITION SIGNALS
signal on_begin_transition
signal on_middle_transition
signal on_end_transition

#LEVEL RELATED
signal on_level_generated
signal on_clear_level
signal on_reach_last_camera_path

#INTERMISSION RELATED
signal on_finish_intermission

#DEBUG MODE RELATED
signal on_debug_teleport_to_boss
