extends State
class_name PlayerDamaged
var _delay : float

var _delayApplied : bool = false

@export var spritetest : Sprite2D
@export var texture : Texture2D
@export var health : Health


func Enter() -> void:	
	_playerResource.Gravity = _playerResource.StartingGravity
	var x_knockback = _playerResource.KnockbackVector.x * (_playerResource.LastDirection * -1)
	var y_knockback = _playerResource.KnockbackVector.y
	
	_playerResource.Velocity = Vector2(x_knockback, y_knockback).normalized() * _playerResource.KnockbackForce
	_playerResource.Agent.velocity = _playerResource.Velocity
	
	_delayApplied = false
	get_tree().create_timer(0.2).timeout.connect(func() : _delayApplied = true)
	
	var state_machine = _playerResource.AnimTree.get("parameters/playback")
	state_machine.travel("Damaged")
	
	SfxManager.do_one_shot("Damage")
	
	SignalBus.on_player_take_damage.emit(health.max_health, health.get_current())

func Exit() -> void:
	_delay = 0.0
	var state_machine = _playerResource.AnimTree.get("parameters/playback")
	state_machine.travel("Idling")

func Update(delta : float) -> void:
	_delay += delta

func Physics_Update(delta : float) -> void:
	var addedGravity = _playerResource.Gravity * delta
	
	if (not _playerResource.Agent.is_on_floor()):
		_playerResource.Velocity.y = clampf(_playerResource.Velocity.y + addedGravity, -_playerResource.FallingCap, _playerResource.FallingCap)
		_playerResource.Agent.velocity = _playerResource.Velocity
	elif (_playerResource.Agent.is_on_floor() && _delayApplied == true):
		if (health.get_current() > 0): Exiting.emit(self, "Normal")
		else: Exiting.emit(self, "Dead")
		
	_playerResource.Agent.move_and_slide()
