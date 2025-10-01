extends State
class_name PlayerNormal

@export var character_body : CharacterBody2D
@export var animation_tree : AnimationTree
@export var subweapon_manager : SubweaponManager
@export var stair_area : Area2D

var state_machine 

func _ready() -> void:
	state_machine = animation_tree.get("parameters/playback")

func Enter() -> void:
	animation_tree.set("parameters/conditions/attack", false)
	animation_tree.set("parameters/conditions/notAttack", true)

func Exit():
	pass

func Update(_delta : float) -> void:
	# If cannot move we don't check anythingd
	if (player_resource.CanMove == false): return
	
	# STAIR MOVEMENT RELATED TRANSITION
	if (Input.is_action_just_pressed("enter_stairs_up") || Input.is_action_just_pressed("enter_stairs_down")):
		if (character_body.is_on_floor()):
			if (stair_area.get_overlapping_areas().size() > 0):
				Exiting.emit(self, "Stairs")
				return
	
	# ATTACK RELATED TRANSITIONS
	if (Input.is_action_just_pressed("attack") and Input.is_action_pressed("ready_subweapon")):
		var moveInt = 0
		if (character_body.is_on_floor()): moveInt = 0
		else: moveInt = 1
		animation_tree.set("parameters/UseSubweapon/Subweapon/blend_position", Vector2(player_resource.LastDirection, moveInt))
		subweapon_manager.try_use_subweapon(
			player_resource.LastDirection, 
			player_resource.Agent)
	elif (Input.is_action_just_pressed("attack")):
		player_resource.WasCrouched = false
		Exiting.emit(self, "Attack")
		return
	
	# CROUCH AND HEALTH RELATED TRANSITIONS
	if (Input.is_action_pressed("crouch")):
		Exiting.emit(self, "Crouch")
		return
	elif (player_resource.HealthComponent.is_damaged):
		Exiting.emit(self, "Damaged")
		return

func Physics_Update(_delta : float) -> void:
	# If cannot move we don't check anything
	if (player_resource.CanMove == false): return
	
	# Gravity	
	var addedGravity = player_resource.Gravity * _delta
	
	# Booleans
	var reachedMaxHeight := (character_body.velocity.y < 0.0 and character_body.velocity.y + addedGravity > 0.0) and not character_body.is_on_floor()
	var isJumping := Input.is_action_just_pressed("jump") and character_body.is_on_floor()
	var isJumpCancelled := Input.is_action_just_released("jump") and player_resource.Velocity.y < 0.0
	
	if (character_body.is_on_floor() == false):
		player_resource.Velocity.y = clampf(player_resource.Velocity.y + addedGravity, -player_resource.FallingCap, player_resource.FallingCap)
	
	# While it's airborn
	if (isJumping):
		player_resource.Velocity.y = -player_resource.JumpForce
		AudioManager.do_one_shot("Jump")
	elif (reachedMaxHeight or isJumpCancelled):
		player_resource.Gravity = player_resource.StartingGravity * player_resource.FallingMultiplier
	elif (character_body.is_on_floor()):
		if (player_resource.Velocity.y != 0):
			AudioManager.do_one_shot("HitGround")
		
		player_resource.Gravity = player_resource.StartingGravity
		player_resource.Velocity.y = 0
	
	# While it's grounded
	if (character_body.is_on_floor()):
		if (Input.is_action_pressed("move_right")):
			player_resource.Velocity.x = 1 * player_resource.Speed
			player_resource.LastDirection = 1
			update_animation()
		elif (Input.is_action_pressed("move_left")):
			player_resource.Velocity.x = -1 * player_resource.Speed
			player_resource.LastDirection = -1
			update_animation()
		else:
			player_resource.Velocity.x = 0
	
	# Stores the direction based on the velocity
	var moveInt : int
	if (character_body.is_on_floor()):
		if (character_body.velocity.x == 0): moveInt = 0
		else: moveInt = 1
	else:
		moveInt = -1
	
	# Updates related blend_position values from the animation tree
	animation_tree.set("parameters/SubAttacking/Movement/blend_position", Vector2(player_resource.LastDirection, moveInt))
	animation_tree.set("parameters/SubAttacking/Subweapon/blend_position", Vector2(player_resource.LastDirection, moveInt))
	
	# Stores the actual velocity and updates the body
	character_body.velocity = player_resource.Velocity
	character_body.move_and_slide()
	
	# In the case that it touched spikes in a frame it inmediatly dies
	# If you don't want this you can change the state to "Damaged" instead
	# or apply your own logic
	for index in character_body.get_slide_collision_count():
		var collision : KinematicCollision2D = character_body.get_slide_collision(index)
		if (collision.get_collider().name == "Spikes"):
			if (collision.get_normal() == Vector2.UP):
				Exiting.emit(self, "Dead")
				break

func update_animation() -> void:
	animation_tree.set("parameters/Idling/blend_position", player_resource.LastDirection)
	animation_tree.set("parameters/Moving/blend_position", player_resource.LastDirection)
	animation_tree.set("parameters/Jumping/blend_position", player_resource.LastDirection)
