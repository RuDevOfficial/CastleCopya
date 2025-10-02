extends Control
# Class that manages all menu UI logic.

@onready var play_button : Button = $"VBoxContainer/Play Button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GStateManager.on_enter_menu.connect(enable_menu)
	GStateManager.on_exit_menu.connect(disable_menu)

func enable_menu() -> void:
	play_button.set_process_input(true)
	play_button.disabled = false
	visible = true

func disable_menu() -> void:
	play_button.set_process_input(false)
	play_button.disabled = true
	visible = false



# THIS BUTTON SHOULD BE REMOVED! THIS IS FOR DEBUG PURPOSES!
func _on_go_to_gameplay_pressed() -> void:
	GStateManager.change_state(GStateManager.GameState.Gameplay)

func _on_delete_save_pressed() -> void:
	SaveManager.clear_save_data(SaveManager.current_save_file_index)

func _on_play_button_pressed() -> void: pass
	# the play button should have the piece of code instead of game_state_manager
	#var game_data : GameplayDataResource = SaveManager.get_current_gameplay_data()
	#if (game_data.INTRO_VIEWED == false):
		#game_data.INTRO_VIEWED = true
		#transition_manager.try_transition(GameState.Intro)
		#SaveManager.save_gameplay_data(SaveManager.current_save_file_index) 
	#else:
		#if (is_debug_mode): transition_manager.try_transition(GameState.Intro)
		#else: transition_manager.try_transition(GameState.Gameplay)
