extends Node
class_name SubweaponManager
# Player class that manages the subweapon system.

var max_uses : int = 20
var current_uses : int = 0

var cooldown_reached : bool = true

@export var starting_uses : int
@export var current_subweapon_data : SubweaponDataResource
@export var animation_tree : AnimationTree

@onready var delay_timer : Timer = $DelayTimer
@onready var cooldown_timer : Timer = $CooldownTimer

var state_machine : AnimationNodeStateMachinePlayback

signal on_weapon_refill
signal on_weapon_use
signal on_subweapon_swapped

func _ready() -> void:
	state_machine = animation_tree.get("parameters/playback")
	SignalBus.on_heart_collected.connect(refill)
	SignalBus.on_subweapon_collected.connect(change_subweapon)
	
	await get_tree().process_frame
	
	cooldown_timer.timeout.connect(func(): 
		animation_tree.set("parameters/UseSubweapon/TimeScale/scale", 1)
		cooldown_reached = true)
	change_subweapon(current_subweapon_data)
	
	refill_uses(current_uses, true)

func refill_uses(amount : int, override_total_uses : bool = false) -> void:
	if (override_total_uses): current_uses = maxi(amount, max_uses)
	else: current_uses = clampi(current_uses + amount, 0, max_uses)
	
	on_weapon_refill.emit(current_uses)

func refill(amount : int) -> void:
	
	current_uses = clampi(current_uses + amount, 0, max_uses)
	on_weapon_refill.emit(current_uses)

func remove_uses(amount : int) -> bool:
	var new_current_uses = current_uses - amount
	if (new_current_uses >= 0): 
		current_uses = new_current_uses
		return true
	else:
		return false

func change_subweapon(new_subweapon_data : SubweaponDataResource) -> void:
	current_subweapon_data = new_subweapon_data
	
	on_subweapon_swapped.emit(current_subweapon_data)

func try_use_subweapon(direction : int, game_object : Node2D) -> void:
	if (can_use_subweapon()): 
		cooldown_reached = false
		use_subweapon(direction, game_object)

func can_use_subweapon() -> bool:
	if (cooldown_reached && current_subweapon_data != null):
		return remove_uses(current_subweapon_data.Cost)
	
	return false

func use_subweapon(direction : int, game_object : Node2D) -> void:
	animation_tree.set("parameters/UseSubweapon/TimeScale/scale", current_subweapon_data.animation_speed)
	animation_tree.set("parameters/conditions/use_subweapon", true)
	animation_tree.set("parameters/conditions/not_use_subweapon", false)
	#state_machine.travel("UseSubweapon")
	
	if (current_subweapon_data.ThrowDelay > 0):
		delay_timer.start(current_subweapon_data.ThrowDelay)
		await delay_timer.timeout
	
	on_weapon_use.emit(current_uses)
	
	#spawn subweapon here
	var subweapon_instance = current_subweapon_data.Scene.instantiate()
	get_tree().root.add_child(subweapon_instance)
	
	if (owner.is_on_floor()): subweapon_instance.global_position = game_object.global_position + Vector2(0, current_subweapon_data.vertical_ground_throw_offset)
	else: subweapon_instance.global_position = game_object.global_position + Vector2(0, current_subweapon_data.vertical_air_throw_offset)
	
	subweapon_instance.throw(Vector2(direction, -1))
	
	cooldown_timer.start(current_subweapon_data.Cooldown)

func stop_subweapon_animation() -> void:
	animation_tree.set("parameters/conditions/use_subweapon", false)
	animation_tree.set("parameters/conditions/not_use_subweapon", true)
