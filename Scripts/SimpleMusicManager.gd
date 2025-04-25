extends FmodEventEmitter2D
@onready var Dead_State = get_tree().root.get_node("Main/Player/FSM/Dead")
@export var PlayerDeathSound : String

func _ready() -> void:
	Dead_State.player_just_died.connect(stop_music)

func stop_music() -> void:
	stop()

func play_music(new_guid : String):
	stop_music()
	event_guid = new_guid
	play()

func _on_scene_switcher_on_level_finish_loading(levelResource : LevelResource) -> void:
	play_music(levelResource.LevelMusicID)
