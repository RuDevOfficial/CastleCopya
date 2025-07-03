extends Camera2D

var follow_Speed : float
@export var player : CharacterBody2D

var is_following_player : bool = true

#func _ready() -> void:
	#get_tree().current_scene.on_load_level.connect(_override_values)

func _override_values(levelResource : LevelResource) -> void:
	self.limit_left = levelResource.TopLeftBounds.x
	self.limit_right = levelResource.BottomRightBounds.x
	#self.limit_top = levelResource.TopLeftBounds.y
	#self.limit_bottom = levelResource.BottomRightBounds.y
	self.follow_Speed = levelResource.PlayerFollowSpeed

func _process(delta: float) -> void:
	if (is_following_player == false): return
	
	self.position.x = player.position.x
