extends State
class_name PlayerNormal

@export var _body2D : CharacterBody2D
@export var _animationTree : AnimationTree
@export_category("Sounds")
@export var _jumpSoundEmitter : FmodEventEmitter2D
@export var _hitGroundSoundEmitter : FmodEventEmitter2D
@export var _collider2D : CollisionShape2D

var _hitGround

func Enter() -> void:
	_animationTree.set("parameters/conditions/attack", false)
	_animationTree.set("parameters/conditions/notAttack", true)

func Exit():
	pass

func Update(_delta : float) -> void:
	# If cannot move we don't check anything
	if (_playerResource.CanMove == false): return
	
	if (Input.is_action_just_pressed("attack")):
		Exiting.emit(self, "Attack")
		
	elif (Input.is_action_just_pressed("crouch")):
		Exiting.emit(self, "Crouch")

func Physics_Update(_delta : float) -> void:
	# If cannot move we don't check anything
	if (_playerResource.CanMove == false): return
	
	# Gravity	
	var addedGravity = _playerResource.Gravity * _delta
	
	var isFalling := _body2D.velocity.y > 0.0 and not _body2D.is_on_floor()
	var reachedMaxHeight := (_body2D.velocity.y < 0.0 and _body2D.velocity.y + addedGravity > 0.0) and not _body2D.is_on_floor()
	var isJumping := Input.is_action_just_pressed("jump") and _body2D.is_on_floor()
	var isJumpCancelled := Input.is_action_just_released("jump") and _playerResource.Velocity.y < 0.0
	
	if (not _body2D.is_on_floor()):
		_playerResource.Velocity.y = clampf(_playerResource.Velocity.y + addedGravity, -_playerResource.FallingCap, _playerResource.FallingCap)
	
	if (isJumping):
		_playerResource.Velocity.y = -_playerResource.JumpForce
		_jumpSoundEmitter.play_one_shot()
	elif (reachedMaxHeight or isJumpCancelled):
		_playerResource.Gravity = _playerResource.StartingGravity * _playerResource.FallingMultiplier
	elif (_body2D.is_on_floor()):
		if (_playerResource.Velocity.y != 0):
			_hitGroundSoundEmitter.play_one_shot()
		
		_playerResource.Gravity = _playerResource.StartingGravity
		_playerResource.Velocity.y = 0
	
	if (_body2D.is_on_floor()):
		if (Input.is_action_pressed("move_right")):
			_playerResource.Velocity.x = 1 * _playerResource.Speed
			_playerResource.LastDirection = 1
		elif (Input.is_action_pressed("move_left")):
			_playerResource.Velocity.x = -1 * _playerResource.Speed
			_playerResource.LastDirection = -1
		else:
			_playerResource.Velocity.x = 0
	
	_body2D.velocity = _playerResource.Velocity
	_body2D.move_and_slide()
	
	_animationTree.set("parameters/Idling/blend_position", _playerResource.LastDirection)
	_animationTree.set("parameters/Moving/blend_position", _playerResource.LastDirection)
	_animationTree.set("parameters/Jumping/blend_position", _playerResource.LastDirection)
	
	for index in _body2D.get_slide_collision_count():
		var collision : KinematicCollision2D = _body2D.get_slide_collision(index)
		if (collision.get_collider().name == "Spikes"):
			if (collision.get_normal() == Vector2.UP):
				Exiting.emit(self, "Dead")
				break
