extends Node
class_name GameStateManager
# One of the core classes. Handles the state of the game, calls signals for each state.
# This is the place if you need to add for example a "Options", "Credits" or "Savefile" states

# VERY IMPORTANT TURN TO FALSE WHEN EXPORTING A BUILD!
var is_debug_mode : bool = false

#region State Signals
signal on_enter_menu
signal on_exit_menu

signal on_enter_intro
signal on_exit_intro

signal on_enter_gameplay
signal on_exit_gameplay

signal on_enter_intermission
signal on_exit_intermission
#endregion

var current_state : GameState = GameState.Ready # Needs to be Ready

enum GameState { Ready, Menu, Options, Intro, Intermission, Gameplay }

var scene_switcher : SceneSwitcher
var transition_manager : TransitionManager

func _ready() -> void:
	connect_signals()
	get_references()
	
	SaveManager.check_for_existing_data()
	
	await get_tree().process_frame
	change_state(GameState.Menu)

func change_state(new_state : GameState) -> void:
	if (new_state == current_state): return
	
	# LEAVE STATE
	if (current_state != null):
		match current_state:
			GameState.Menu: exit_menu()
			GameState.Options: pass
			GameState.Intro: exit_intro()
			GameState.Intermission: exit_intermission()
			GameState.Gameplay: exit_gameplay()
	
	# ENTER STATE
	match new_state:
		GameState.Menu: enter_menu()
		GameState.Options: pass
		GameState.Intro: enter_intro()
		GameState.Intermission: enter_intermission()
		GameState.Gameplay: enter_gameplay()
	
	current_state = new_state

#region State Entries and Exits

func enter_menu() -> void: on_enter_menu.emit()
func exit_menu() -> void: on_exit_menu.emit()

func enter_intro() -> void: on_enter_intro.emit()
func exit_intro() -> void: on_exit_intro.emit()

func enter_gameplay() -> void:
	var current_gameplay_data : GameplayDataResource = SaveManager.get_current_gameplay_data()
	StageManager.generate_new_level(current_gameplay_data.CURRENT_LEVEL)
	on_enter_gameplay.emit()
func exit_gameplay() -> void: on_exit_gameplay.emit()

func enter_intermission() -> void: on_enter_intermission.emit()
func exit_intermission() -> void: on_exit_intermission.emit()

#endregion

func connect_signals() -> void:
	
	# The play button starts the game, loads the level if the player already saw the cutscene
	var play_button : Button = get_tree().root.get_node("Main/UI/Menu/VBoxContainer/Play Button")
	play_button.pressed.connect(func():
		var game_data : GameplayDataResource = SaveManager.get_current_gameplay_data()
		if (game_data.INTRO_VIEWED == false):
			game_data.INTRO_VIEWED = true
			transition_manager.try_transition(GameState.Intro)
			SaveManager.save_gameplay_data(SaveManager.current_save_file_index) 
		else:
			if (is_debug_mode): transition_manager.try_transition(GameState.Intro)
			else: transition_manager.try_transition(GameState.Gameplay)
	)
	
	var intro_control : Control = get_tree().root.get_node("Main/UI/Intro")
	intro_control.intro_cutscene_finished.connect(func(): 
		transition_manager.try_transition(GameState.Gameplay)
		)
	
	# If a level is clear it transitions to an intermission cutscene
	SignalBus.on_clear_level.connect(func():
		await get_tree().create_timer(4).timeout #HARDCODED TIME, CAN BE CHANGED
		transition_manager.try_transition(GameState.Intermission)
		)
	
	SignalBus.on_finish_intermission.connect(func():
		transition_manager.try_transition(GameState.Gameplay)
		)

func get_references() -> void:
	scene_switcher = get_tree().root.get_node("Main/Managers/SceneSwitcher")
	transition_manager = get_tree().root.get_node("Main/Managers/TransitionManager")
