extends Control

@onready var play_button : Button = $"Play Button"

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
