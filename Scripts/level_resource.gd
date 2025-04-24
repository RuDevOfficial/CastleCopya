@tool
extends Resource
class_name LevelResource

@export_category("Camera")
@export var TopLeftBounds : Vector2
@export var BottomRightBounds : Vector2
@export var PlayerFollowSpeed : float

@export_category("Level Transition")
@export_tool_button("Get Current Player Position", "Callable")
var _getPlayerButton = set_player_location_to_current.bind()
@export var PlayerSpawnPosition : Vector2;
@export var LevelLoadSpeed : float;
@export var LevelName : String
@export var RequiresFadeIn : bool
@export var LookLeftOnLoad : bool

func set_player_location_to_current() -> void:
	var playerNode : CharacterBody2D = (EditorInterface.get_edited_scene_root().get_node("Player"))
	PlayerSpawnPosition = playerNode.global_position
