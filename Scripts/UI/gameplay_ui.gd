extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	disable_ui()

func connect_signals() -> void:
	GStateManager.on_enter_gameplay.connect(enable_ui)
	GStateManager.on_exit_gameplay.connect(disable_ui)

func enable_ui() -> void:
	visible = true

func disable_ui() -> void:
	visible = false
