extends State
class_name PlayerCrouch
@export var _animationTree : AnimationTree

# Sets proper blend tree values in the animationtree on entering and exiting
func Enter() -> void:
	_animationTree.set("parameters/conditions/attack", false)
	_animationTree.set("parameters/conditions/notAttack", true)
	_animationTree.set("parameters/conditions/crouching", true)
	_animationTree.set("parameters/conditions/notCrouching", false)
	_animationTree.set("parameters/Crouching/blend_position", player_resource.LastDirection)

func Exit() -> void:
	_animationTree.set("parameters/conditions/attack", false)
	_animationTree.set("parameters/conditions/notAttack", true)
	_animationTree.set("parameters/conditions/crouching", false)
	_animationTree.set("parameters/conditions/notCrouching", true)
	_animationTree.set("parameters/Crouching/blend_position", player_resource.LastDirection)

func Update(_delta : float) -> void:
	update_player_direction()
	
	# Checking for other actions that could change their state
	if (player_resource.HealthComponent.is_damaged):
		Exiting.emit(self, "Damaged")
	elif (Input.is_action_just_pressed("attack")):
		player_resource.WasCrouched = true
		Exiting.emit(self, "Attack")
	elif (Input.is_action_pressed("crouch") == false):
		Exiting.emit(self, "Normal")

# The crouching state can only be done while grounded and they cannot move
# You can always let the player move by adding a few lines of code
func Physics_Update(_delta : float) -> void:
	var addedGravity = player_resource.Gravity * _delta
	var reachedMaxHeight : bool = (player_resource.Agent.velocity.y < 0.0 and player_resource.Agent.velocity.y + addedGravity > 0.0) and not player_resource.Agent.is_on_floor()
	var isJumpCancelled := Input.is_action_just_released("jump") and player_resource.Velocity.y < 0.0
	
	if (reachedMaxHeight or isJumpCancelled):
		player_resource.Gravity = player_resource.StartingGravity * player_resource.FallingMultiplier
	
	if (not player_resource.Agent.is_on_floor()):
		player_resource.Velocity.y = clampf(player_resource.Velocity.y + addedGravity, -player_resource.FallingCap, player_resource.FallingCap)
	else:
		player_resource.Velocity.y = 0
		player_resource.Velocity.x = 0
	
	player_resource.Agent.velocity = player_resource.Velocity
	player_resource.Agent.move_and_slide()
	
	for index in player_resource.Agent.get_slide_collision_count():
		var collision : KinematicCollision2D = player_resource.Agent.get_slide_collision(index)
		if (collision.get_collider().name == "Spikes"):
			if (collision.get_normal() == Vector2.UP):
				Exiting.emit(self, "Dead")
				break

func update_player_direction() -> void:
	if (Input.is_action_pressed("move_right")):
		player_resource.LastDirection = 1
		_animationTree.set("parameters/Crouching/blend_position", player_resource.LastDirection)
	elif (Input.is_action_pressed("move_left")):
		player_resource.LastDirection = -1
		_animationTree.set("parameters/Crouching/blend_position", player_resource.LastDirection)
