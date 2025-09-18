extends Control

@onready var animation_player : AnimationPlayer = $AnimationPlayer

signal intro_cutscene_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	
	disable_intro()

func connect_signals() -> void:
	GStateManager.on_enter_intro.connect(initialize_intro)
	GStateManager.on_exit_intro.connect(disable_intro)

func initialize_intro() -> void:
	visible = true
	AudioManager.do_one_shot("Intro")
	animation_player.play("running")

func disable_intro() -> void:
	visible = false

# THIS METHOD IS CALLED WITHIN THE ANIMATION
func cutscene_finished() -> void:
	intro_cutscene_finished.emit()
