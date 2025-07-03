extends State
class_name PlayerAttack

@export var _body2D : CharacterBody2D
@export var _attackTimer : Timer
@export var _animationTree : AnimationTree

var is_attacking : bool = false

func Enter() -> void:
	is_attacking = true
	
	_animationTree.set("parameters/conditions/attack", true)
	_animationTree.set("parameters/conditions/notAttack", false)
	
	var crouched : int
	if (_playerResource.WasCrouched == false): crouched = 1
	else: crouched = -1
	
	_animationTree.set("parameters/Attacking/blend_position", Vector2(_playerResource.LastDirection, crouched))
	
	_attackTimer.start(_playerResource.AttackTime)
	
	if (_body2D.is_on_floor()):
		_playerResource.Velocity.x = 0

func Exit() -> void:
	is_attacking = false

func Update(_delta : float) -> void:
	pass

func Physics_Update(_delta : float) -> void:
	
	var addedGravity = _playerResource.Gravity * _delta
	var reachedMaxHeight := (_body2D.velocity.y < 0.0 and _body2D.velocity.y + addedGravity > 0.0) and not _body2D.is_on_floor()
	var isJumpCancelled := Input.is_action_just_released("jump") and _playerResource.Velocity.y < 0.0
	
	if (reachedMaxHeight or isJumpCancelled):
		_playerResource.Gravity = _playerResource.StartingGravity * _playerResource.FallingMultiplier
	
	if (not _body2D.is_on_floor()):
		_playerResource.Velocity.y = clampf(_playerResource.Velocity.y + addedGravity, -_playerResource.FallingCap, _playerResource.FallingCap)
	else:
		_playerResource.Velocity.y = 0
		_playerResource.Velocity.x = 0
	
	_body2D.velocity = _playerResource.Velocity
	_body2D.move_and_slide()


func _on_attack_timer_timeout() -> void:
	if (_playerResource.WasCrouched == false):
		Exiting.emit(self, "Normal")
	else:
		Exiting.emit(self, "Crouch")

func _on_health_damaged(amount: float, knockback: Vector2) -> void:
	if (is_attacking == false): return
	
	_attackTimer.stop()
	Exiting.emit(self, "Damaged")
