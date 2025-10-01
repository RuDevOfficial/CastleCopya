extends State
class_name PlayerDamaged

@export var spritetest : Sprite2D
@export var texture : Texture2D
@export var health : Health

# The amount of time it takes for the damaged state to end
var delay_amount : float = 0.2
var delay_applied : bool = false

func Enter() -> void:	
	# Required to add vertical momentum at the start of the state
	player_resource.Gravity = player_resource.StartingGravity
	
	apply_starting_knockback()
	create_damaged_timer()
	
	# Travels directly to the "Damaged" state in the tree
	# regardless of where it was before
	player_resource.AnimTree.get("parameters/playback").travel("Damaged")
	
	AudioManager.do_one_shot("Damage")
	
	# Needed to emit here so the UI can update when needed and not every frame
	SignalBus.on_player_take_damage.emit(player_resource.StartingHealth, health.get_current())

func Exit() -> void:
	var state_machine = player_resource.AnimTree.get("parameters/playback")
	state_machine.travel("Idling")

func Update(delta : float) -> void:
	pass

func Physics_Update(delta : float) -> void:
	var addedGravity = player_resource.Gravity * delta
	
	# Even if the timer has ended, unless the player has hit the ground it will stay
	# in this state, good if you want the player to stay a necessary amount stunned
	# before they are allowed to move
	if (not player_resource.Agent.is_on_floor()):
		player_resource.Velocity.y = clampf(player_resource.Velocity.y + addedGravity, -player_resource.FallingCap, player_resource.FallingCap)
		player_resource.Agent.velocity = player_resource.Velocity
	elif (player_resource.Agent.is_on_floor() && delay_applied == true):
		if (health.get_current() > 0): Exiting.emit(self, "Normal")
		else: Exiting.emit(self, "Dead")
		
	player_resource.Agent.move_and_slide()

func apply_starting_knockback() -> void:
	var x_knockback = player_resource.KnockbackVector.x * (player_resource.LastDirection * -1)
	var y_knockback = player_resource.KnockbackVector.y
	
	player_resource.Velocity = Vector2(x_knockback, y_knockback).normalized() * player_resource.KnockbackForce
	player_resource.Agent.velocity = player_resource.Velocity

func create_damaged_timer() -> void:
	delay_applied = false
	get_tree().create_timer(delay_amount).timeout.connect(func() : delay_applied = true)
