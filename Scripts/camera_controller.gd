extends Camera2D

var follow_Speed : float
var player : CharacterBody2D

func _ready() -> void:
	get_tree().current_scene.on_load_level.connect(_override_values)
	player = get_node("../Player")

func _override_values(levelResource : LevelResource) -> void:
	self.limit_left = levelResource.TopLeftBounds.x
	self.limit_right = levelResource.BottomRightBounds.x
	#self.limit_top = levelResource.TopLeftBounds.y
	#self.limit_bottom = levelResource.BottomRightBounds.y
	self.follow_Speed = levelResource.PlayerFollowSpeed

func _physics_process(delta : float) -> void:
	self.position.x = player.position.x
