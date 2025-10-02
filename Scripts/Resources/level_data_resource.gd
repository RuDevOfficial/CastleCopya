@tool
extends Resource
class_name LevelResource
# Resource that stores all necessary information of a level.
# (see Resources/Levels for an example)
# All data is read only (never modified at runtime)
# You can set up the player's starting position from the inspector window

@export var level_scene : PackedScene
@export var level_boss : PackedScene

@export_category("Level Transition")
@export_tool_button("Get Current Player Position", "Callable")
var _getPlayerButton = set_player_location_to_current.bind()
@export var PlayerSpawnPosition : Vector2;
@export var LevelName : String
@export var LookLeftOnLoad : bool
@export var RequiresIntermission : bool
@export var StageEndEvent : EndEvent = EndEvent.None

@export_category("Audio")
@export var LevelMusicID : String
@export var boss_theme_name : String

func set_player_location_to_current() -> void:
	var playerNode : CharacterBody2D = (EditorInterface.get_edited_scene_root().get_node("Player"))
	PlayerSpawnPosition = playerNode.global_position

enum EndEvent { None, Boss }
