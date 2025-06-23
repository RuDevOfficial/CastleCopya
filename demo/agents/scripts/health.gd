#*
#* health.gd
#* =============================================================================
#* Copyright (c) 2023-present Serhii Snitsaruk and the LimboAI contributors.
#*
#* Use of this source code is governed by an MIT-style
#* license that can be found in the LICENSE file or at
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
class_name Health
extends Node
## Tracks health and emits signal when damaged or dead.

## Emitted when health is reduced to 0.
signal death

## Emitted when health is damaged.
signal damaged(amount: float, knockback: Vector2)

## Initial health value.
@export var max_health: float
@export var damage_sound_emitter : FmodEventEmitter2D

@export var invincible_time : float = 0.0
@export var hurtbox : Hurtbox
var is_invincible : bool = false

var _current : float
var is_damaged : bool = false

var last_damage_amount : float = 0
var last_knockback : Vector2

func _ready() -> void:
	_current = max_health


func take_damage(amount: float, knockback: Vector2) -> void:
	if is_invincible == true: return
	if _current <= 0.0: return
	
	last_damage_amount = amount
	last_knockback = knockback
	
	_current -= amount
	_current = max(_current, 0.0)
	is_damaged = true
	
	if _current <= 0.0:
		death.emit()
	else:
		damaged.emit(amount, knockback)
		if (damage_sound_emitter != null): damage_sound_emitter.play_one_shot()
		
		if (invincible_time > 0.0): 
			is_invincible = true
			hurtbox.get_child(0).disabled = true
			get_tree().create_timer(invincible_time).timeout.connect(re_enable)
		
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		is_damaged = false

func re_enable():
	is_invincible = false 
	hurtbox.get_child(0).disabled = false
	
	if (hurtbox.get_overlapping_areas().size() > 0): take_damage(last_damage_amount, last_knockback)

## Returns current health.
func get_current() -> float:
	return _current

func set_health(new_amount : int):
	_current = new_amount
