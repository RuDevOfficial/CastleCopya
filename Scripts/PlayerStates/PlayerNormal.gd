extends State
class_name PlayerNormal

@export var _body2D : CharacterBody2D
@export var _animationTree : AnimationTree
@export_category("Sounds")

@export var subweapon_manager : SubweaponManager

func Enter() -> void:
	_animationTree.set("parameters/conditions/attack", false)
	_animationTree.set("parameters/conditions/notAttack", true)

func Exit():
	pass

func Update(_delta : float) -> void:
	# If cannot move we don't check anythingd
	if (_playerResource.CanMove == false): return
	
	if (Input.is_action_just_pressed("attack") and Input.is_action_pressed("ready_subweapon")):
		subweapon_manager.try_use_subweapon(
			_playerResource.LastDirection, 
			_playerResource.Agent)
	elif (Input.is_action_just_pressed("attack")):
		_playerResource.WasCrouched = false
		Exiting.emit(self, "Attack")
	
	if (Input.is_action_pressed("crouch")):
		Exiting.emit(self, "Crouch")
	elif (_playerResource.HealthComponent.is_damaged):
		Exiting.emit(self, "Damaged")

func Physics_Update(_delta : float) -> void:
	# If cannot move we don't check anything
	if (_playerResource.CanMove == false): return
	
	# Gravity	
	var addedGravity = _playerResource.Gravity * _delta
	
	var reachedMaxHeight := (_body2D.velocity.y < 0.0 and _body2D.velocity.y + addedGravity > 0.0) and not _body2D.is_on_floor()
	var isJumping := Input.is_action_just_pressed("jump") and _body2D.is_on_floor()
	var isJumpCancelled := Input.is_action_just_released("jump") and _playerResource.Velocity.y < 0.0
	
	if (not _body2D.is_on_floor()):
		_playerResource.Velocity.y = clampf(_playerResource.Velocity.y + addedGravity, -_playerResource.FallingCap, _playerResource.FallingCap)
	
	if (isJumping):
		_playerResource.Velocity.y = -_playerResource.JumpForce
		SfxManager.do_one_shot("Jump")
	elif (reachedMaxHeight or isJumpCancelled):
		_playerResource.Gravity = _playerResource.StartingGravity * _playerResource.FallingMultiplier
	elif (_body2D.is_on_floor()):
		if (_playerResource.Velocity.y != 0):
			SfxManager.do_one_shot("HitGround")
		
		_playerResource.Gravity = _playerResource.StartingGravity
		_playerResource.Velocity.y = 0
	
	if (_body2D.is_on_floor()):
		if (Input.is_action_pressed("move_right")):
			_playerResource.Velocity.x = 1 * _playerResource.Speed
			_playerResource.LastDirection = 1
			update_animation()
		elif (Input.is_action_pressed("move_left")):
			_playerResource.Velocity.x = -1 * _playerResource.Speed
			_playerResource.LastDirection = -1
			update_animation()
		else:
			_playerResource.Velocity.x = 0
	
	var moveInt : int
	if (_body2D.is_on_floor()):
		if (_body2D.velocity.x == 0): moveInt = 0
		else: moveInt = 1
	else:
		moveInt = -1
	
	_animationTree.set("parameters/SubAttacking/Movement/blend_position", Vector2(_playerResource.LastDirection, moveInt))
	_animationTree.set("parameters/SubAttacking/Subweapon/blend_position", Vector2(_playerResource.LastDirection, moveInt))
	
	_body2D.velocity = _playerResource.Velocity
	_body2D.move_and_slide()
	
	for index in _body2D.get_slide_collision_count():
		var collision : KinematicCollision2D = _body2D.get_slide_collision(index)
		if (collision.get_collider().name == "Spikes"):
			if (collision.get_normal() == Vector2.UP):
				Exiting.emit(self, "Dead")
				break

func update_animation() -> void:
	_animationTree.set("parameters/Idling/blend_position", _playerResource.LastDirection)
	_animationTree.set("parameters/Moving/blend_position", _playerResource.LastDirection)
	_animationTree.set("parameters/Jumping/blend_position", _playerResource.LastDirection)


#func spawn_subweapon(totalSubweaponuses : float) -> void:
	#_playerResource.SubweaponUses = clampi(totalSubweaponuses, 0, _playerResource.SubweaponUses)
	#_animationTree.set("parameters/conditions/subweapon", true)
	#_animationTree.set("parameters/conditions/notSubweapon", false)
	#_playerResource.SubweaponUsedTrigger = true
	#
	#var instance : Subweapon = _playerResource.CurrentSubweapon.Scene.instantiate()
	#get_tree().root.add_child(instance)
	#instance.global_position = _playerResource.Agent.global_position
	#instance.throw(Vector2(_playerResource.LastDirection, -1))
	#
	#await get_tree().create_timer(_playerResource.CurrentSubweapon.Cooldown).timeout
	#
	#_animationTree.set("parameters/conditions/subweapon", false)
	#_animationTree.set("parameters/conditions/notSubweapon", true)
	#can_use_subweapon = true
