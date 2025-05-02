extends State
class_name PlayerCrouch
@export var _animationTree : AnimationTree

func Enter() -> void:
	_animationTree.set("parameters/conditions/attack", false)
	_animationTree.set("parameters/conditions/notAttack", true)
	_animationTree.set("parameters/conditions/crouching", true)
	_animationTree.set("parameters/conditions/notCrouching", false)
	_animationTree.set("parameters/Crouching/blend_position", _playerResource.LastDirection)

func Exit() -> void:
	_animationTree.set("parameters/conditions/attack", false)
	_animationTree.set("parameters/conditions/notAttack", true)
	_animationTree.set("parameters/conditions/crouching", false)
	_animationTree.set("parameters/conditions/notCrouching", true)
	_animationTree.set("parameters/Crouching/blend_position", _playerResource.LastDirection)

func Update(_delta : float) -> void:
	if (Input.is_action_pressed("move_right")):
		_playerResource.LastDirection = 1
		_animationTree.set("parameters/Crouching/blend_position", _playerResource.LastDirection)
	elif (Input.is_action_pressed("move_left")):
		_playerResource.LastDirection = -1
		_animationTree.set("parameters/Crouching/blend_position", _playerResource.LastDirection)

	if (_playerResource.HealthComponent.is_damaged):
		Exiting.emit(self, "Damaged")
	elif (Input.is_action_just_pressed("attack")):
		_playerResource.WasCrouched = true
		Exiting.emit(self, "Attack")
	elif (Input.is_action_pressed("crouch") == false):
		Exiting.emit(self, "Normal")


func Physics_Update(_delta : float) -> void:
	
	var addedGravity = _playerResource.Gravity * _delta
	var reachedMaxHeight : bool = (_playerResource.Agent.velocity.y < 0.0 and _playerResource.Agent.velocity.y + addedGravity > 0.0) and not _playerResource.Agent.is_on_floor()
	var isJumpCancelled := Input.is_action_just_released("jump") and _playerResource.Velocity.y < 0.0
	
	if (reachedMaxHeight or isJumpCancelled):
		_playerResource.Gravity = _playerResource.StartingGravity * _playerResource.FallingMultiplier
	
	if (not _playerResource.Agent.is_on_floor()):
		_playerResource.Velocity.y = clampf(_playerResource.Velocity.y + addedGravity, -_playerResource.FallingCap, _playerResource.FallingCap)
	else:
		_playerResource.Velocity.y = 0
		_playerResource.Velocity.x = 0
	
	_playerResource.Agent.velocity = _playerResource.Velocity
	_playerResource.Agent.move_and_slide()
	
	for index in _playerResource.Agent.get_slide_collision_count():
		var collision : KinematicCollision2D = _playerResource.Agent.get_slide_collision(index)
		if (collision.get_collider().name == "Spikes"):
			if (collision.get_normal() == Vector2.UP):
				Exiting.emit(self, "Dead")
				break
