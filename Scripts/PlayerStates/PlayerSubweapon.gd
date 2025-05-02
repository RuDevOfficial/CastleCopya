extends State
class_name PlayerSubweapon
@export var normal_state : PlayerNormal

func Enter() -> void:
	var subweapon : Subweapon = _playerResource.CurrentSubweapon.instantiate()
	get_tree().root.get_node("Main").add_child(subweapon)
	subweapon.global_position = _playerResource.Agent.global_position
	
	var timer = get_tree().create_timer(subweapon.Subweapon_Resource.ThrowDelay)
	timer.timeout.connect(_on_timeout)
	
	subweapon.throw(Vector2(_playerResource.LastDirection, 0))

func Exit() -> void:
	pass

func Update(_delta : float) -> void:
	pass

func Physics_Update(delta : float) -> void:
	normal_state.Physics_Update(delta)
	
	#var addedGravity = _playerResource.Gravity * delta
	#
	#if (not _playerResource.Agent.is_on_floor()):
		#_playerResource.Velocity.y = clampf(_playerResource.Velocity.y + addedGravity, -_playerResource.FallingCap, _playerResource.FallingCap)
		#_playerResource.Agent.velocity = _playerResource.Velocity
	#else:
		#_playerResource.Velocity.y = 0
		#_playerResource.Velocity.x = 0
	#
	#_playerResource.Agent.velocity = _playerResource.Velocity
	#_playerResource.Agent.move_and_slide()

func _on_timeout() -> void:
	Exiting.emit(self, "Normal")
