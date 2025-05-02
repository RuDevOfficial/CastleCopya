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

var _current : float
var is_damaged : bool = false

func _ready() -> void:
	_current = max_health


func take_damage(amount: float, knockback: Vector2) -> void:
	if _current <= 0.0:
		return
	
	_current -= amount
	_current = max(_current, 0.0)
	
	if (damage_sound_emitter != null):
		damage_sound_emitter.play_one_shot()
	
	if _current <= 0.0:
		death.emit()
	else:
		damaged.emit(amount, knockback)
		is_damaged = true
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		is_damaged = false


## Returns current health.
func get_current() -> float:
	return _current
