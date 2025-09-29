extends State
class_name PlayerDamaged
var _delay : float

var _delayApplied : bool = false

@export var spritetest : Sprite2D
@export var texture : Texture2D
@export var health : Health


func Enter() -> void:	
	player_resource.Gravity = player_resource.StartingGravity
	var x_knockback = player_resource.KnockbackVector.x * (player_resource.LastDirection * -1)
	var y_knockback = player_resource.KnockbackVector.y
	
	player_resource.Velocity = Vector2(x_knockback, y_knockback).normalized() * player_resource.KnockbackForce
	player_resource.Agent.velocity = player_resource.Velocity
	
	_delayApplied = false
	get_tree().create_timer(0.2).timeout.connect(func() : _delayApplied = true)
	
	var state_machine = player_resource.AnimTree.get("parameters/playback")
	state_machine.travel("Damaged")
	
	AudioManager.do_one_shot("Damage")
	
	SignalBus.on_player_take_damage.emit(player_resource.StartingHealth, health.get_current())

func Exit() -> void:
	_delay = 0.0
	var state_machine = player_resource.AnimTree.get("parameters/playback")
	state_machine.travel("Idling")

func Update(delta : float) -> void:
	_delay += delta

func Physics_Update(delta : float) -> void:
	var addedGravity = player_resource.Gravity * delta
	
	if (not player_resource.Agent.is_on_floor()):
		player_resource.Velocity.y = clampf(player_resource.Velocity.y + addedGravity, -player_resource.FallingCap, player_resource.FallingCap)
		player_resource.Agent.velocity = player_resource.Velocity
	elif (player_resource.Agent.is_on_floor() && _delayApplied == true):
		if (health.get_current() > 0): Exiting.emit(self, "Normal")
		else: Exiting.emit(self, "Dead")
		
	player_resource.Agent.move_and_slide()
