extends State
class_name PlayerAttack

@export var _body2D : CharacterBody2D
@export var _attackTimer : Timer
@export var _animationTree : AnimationTree

var is_attacking : bool = false

func Enter() -> void:
	is_attacking = true
	
	var crouched : int
	if (player_resource.WasCrouched == false): crouched = 1
	else: crouched = -1
	
	_animationTree.set("parameters/conditions/attack", true)
	_animationTree.set("parameters/conditions/notAttack", false)
	_animationTree.set("parameters/Attacking/blend_position", Vector2(player_resource.LastDirection, crouched))
	
	_attackTimer.start(player_resource.AttackTime)
	
	if (_body2D.is_on_floor()):
		player_resource.Velocity.x = 0

func Exit() -> void:
	is_attacking = false

func Update(_delta : float) -> void:
	pass

# The player can't jump, but can still fall
func Physics_Update(_delta : float) -> void:
	
	var addedGravity = player_resource.Gravity * _delta
	var reachedMaxHeight := (_body2D.velocity.y < 0.0 and _body2D.velocity.y + addedGravity > 0.0) and not _body2D.is_on_floor()
	var isJumpCancelled := Input.is_action_just_released("jump") and player_resource.Velocity.y < 0.0
	
	if (reachedMaxHeight or isJumpCancelled):
		player_resource.Gravity = player_resource.StartingGravity * player_resource.FallingMultiplier
	
	if (not _body2D.is_on_floor()):
		player_resource.Velocity.y = clampf(player_resource.Velocity.y + addedGravity, -player_resource.FallingCap, player_resource.FallingCap)
	else:
		player_resource.Velocity.y = 0
		player_resource.Velocity.x = 0
	
	_body2D.velocity = player_resource.Velocity
	_body2D.move_and_slide()


func _on_attack_timer_timeout() -> void:
	if (player_resource.WasCrouched == false):
		Exiting.emit(self, "Normal")
	else:
		Exiting.emit(self, "Crouch")

func _on_health_damaged(amount: float, knockback: Vector2) -> void:
	if (is_attacking == false): return
	
	_attackTimer.stop()
	Exiting.emit(self, "Damaged")
